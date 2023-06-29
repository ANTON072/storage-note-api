module Api
  module V1
    class UsersController < ApplicationController
      def show
        auth_header = request.headers['Authorization']
        token       = auth_header.split('Bearer ').last
        verify_id_token token
        user = { id: 1, name: 'hoge' }
        render json: user
      end

      private

      def verify_id_token(token)
        # See: https://firebase.google.com/docs/auth/admin/verify-id-tokens?hl=ja

        firebase_project_id = Rails.application.credentials.firebase[:project_id]

        # JWTヘッダで指定されている署名アルゴリズムを検証
        encoded_header = token.split('.').first
        decode_header  = JSON.parse(Base64.decode64(encoded_header))
        alg            = decode_header['alg']
        raise "Invalid token 'alg' header (#{alg})." if alg != 'RS256'

        # JWTを検証するための公開鍵をダウンロードする
        # 一度取得したら更新期限まで内容をキャッシュする
        public_keys = Rails.cache.fetch('public_keys', expires_in: cache_expiry_time) do
          response = HTTParty.get('https://www.googleapis.com/robot/v1/metadata/x509/securetoken@system.gserviceaccount.com')
          raise 'Failed to fetch JWT public keys' unless response.success?

          parsed_response = response.parsed_response

          # max-ageを抽出する
          cache_control_header = response.headers['cache-control']
          cache_expiry_time    = get_expiry_time_from_cache_control(cache_control_header)

          # キャッシュに書き込む
          Rails.cache.write('public_keys_expiry_time', cache_expiry_time, expires_in: cache_expiry_time)

          parsed_response
        end

        kid = decode_header['kid']

        raise "Invalid token 'kid' header" unless public_keys.include?(kid)

        # OpenSSLのX.509証明書オブジェクトに変換
        # PEM形式からOpenSSLライブラリで利用できる形式に変換する
        public_key = OpenSSL::X509::Certificate.new(public_keys[kid]).public_key

        # JWTトークンの検証
        options = {
          algorithm: 'RS256',
          verify_iat: true,
          verify_aud: true,
          aud: firebase_project_id,
          verify_iss: true,
          iss: "https://securetoken.google.com/#{firebase_project_id}"
        }

        decoded_token = JWT.decode(token, public_key, true, options)

        pp decoded_token
      end

      def cache_expiry_time
        # 公開鍵を更新する時期をキャッシュから取得する。なければ1時間後
        Rails.cache.read('public_keys_expiry_time') || 1.hour
      end

      def get_expiry_time_from_cache_control(cache_control_header)
        _, max_age = cache_control_header.match(/max-age=(\d+)/).to_a
        # 秒数に変換
        max_age.to_i.seconds
      end

    end

  end
end

