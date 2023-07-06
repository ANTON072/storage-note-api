class ApplicationController < ActionController::API

  include ErrorHandler

  FIREBASE_PROJECT_ID = Rails.configuration.firebase[:FIREBASE_PROJECT_ID]
  GOOGLE_PUBLIC_KEYS_API = 'https://www.googleapis.com/robot/v1/metadata/x509/securetoken@system.gserviceaccount.com'.freeze
  ALG = 'RS256'.freeze

  before_action :verify_id_token

  private

  def render_errors(errors)
    formatted_errors = errors.map do |error|
      {
        status: error[:status].to_s,
        title: error[:title],
        detail: error[:detail],
        source: {
          pointer: error[:path]
        }
      }
    end

    render json: { errors: formatted_errors }, status: errors.first[:status]
  end

  def firebase_user
    @decoded_token.first
  end

  def current_user
    User.find_by!(firebase_uid: firebase_user['user_id'])
  end

  # Firebase idTokenの認証
  # See: https://firebase.google.com/docs/auth/admin/verify-id-tokens?hl=ja
  def verify_id_token
    auth_header = request.headers['Authorization']
    raise AuthenticationError, '認証エラー' unless auth_header.is_a?(String)

    token = auth_header.split('Bearer ').last
    raise AuthenticationError, '認証エラー' unless token.is_a?(String)

    kid = validate_jwt_algorithm(token)

    public_key = get_public_key(kid)

    @decoded_token = decode_jwt(token, public_key)
  end

  # JWTヘッダで指定されている署名アルゴリズムを検証
  def validate_jwt_algorithm(token)
    encoded_header = token.split('.').first
    decoded_header = JSON.parse(Base64.decode64(encoded_header))
    alg            = decoded_header['alg']
    raise AuthenticationError, '認証エラー' if alg != ALG

    kid = decoded_header['kid']
    raise AuthenticationError, '認証エラー' unless kid

    kid
  end

  # JWTを検証するために公開鍵をGoogleからダウンロード
  def get_public_key(kid)
    # 一度ダウンロードしたら更新期限までキャッシュする
    # public_keys = get_public_keys
    raise AuthenticationError, '認証エラー' unless public_keys.include?(kid)

    # OpenSSLのX.509証明書オブジェクトに変換
    # PEM形式からOpenSSLライブラリで利用できる形式に変換する
    OpenSSL::X509::Certificate.new(public_keys[kid]).public_key
  end

  def public_keys
    # 一度ダウンロードしたら更新期限までキャッシュする
    Rails.cache.fetch('public_keys', expires_in: cache_expiry_time) do
      response = HTTParty.get(GOOGLE_PUBLIC_KEYS_API)
      raise AuthenticationError, '認証エラー' unless response.success?

      # 更新期限の取得
      cache_expiry_time = get_max_age(response.headers['cache-control'])
      # キャッシュに書き込む
      Rails.cache.write(
        'public_keys_expiry_time',
        cache_expiry_time,
        expires_in: cache_expiry_time
      )
      response.parsed_response
    end
  end

  # max-ageの抽出
  def get_max_age(cache_control_header)
    return 1.hour unless cache_control_header.is_a?(String)

    _, max_age = cache_control_header.match(/max-age=(\d+)/).to_a
    # 秒数に変換
    max_age.to_i.seconds
  end

  # キャッシュ有効期限
  def cache_expiry_time
    Rails.cache.read('public_keys_expiry_time') || 1.hour
  end

  # JWTデコードの実行
  def decode_jwt(token, public_key)
    options = {
      algorithm: ALG,
      verify_iat: true,
      verify_aud: true,
      aud: FIREBASE_PROJECT_ID,
      verify_iss: true,
      iss: "https://securetoken.google.com/#{FIREBASE_PROJECT_ID}",
      # トークンの期限切れ検証
      verify_expiration: true
    }

    begin
      JWT.decode(token, public_key, true, options)
    rescue JWT::ExpiredSignature => _e
      raise AuthenticationError, '認証エラー: トークンが期限切れです。'
    rescue JWT::DecodeError => e
      raise AuthenticationError, "認証エラー: #{e.message}"
    end
  end
end
