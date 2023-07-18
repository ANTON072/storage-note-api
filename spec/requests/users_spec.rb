# rubocop:disable all
require 'rails_helper'

RSpec.describe 'Api::V1::Users', type: :request do
  describe 'GET /v1/user' do
    # ユーザーをテストDBに保存
    let(:user) { create(:user) }
    let(:headers) { { 'Authorization' => "Bearer #{user.firebase_uid}" } }

    before do
      allow_any_instance_of(ApplicationController).to receive(:verify_id_token).and_return(nil)
      allow_any_instance_of(ApplicationController).to receive(:firebase_user)
                                        .and_return({
                                                      user_id: user.firebase_uid,
                                                      email: user.email
                                                    })
      allow_any_instance_of(ApplicationController).to receive(:current_user)
                                                        .and_return(user)
    end

    context 'リクエストがvalid' do
      before do
        get v1_user_path, headers:
      end

      it 'ステータスコードが200' do
        expect(response).to have_http_status(:success)
      end

      it 'ユーザーデータを返す' do
        expect(response.parsed_body).to include('name' => user.name)
      end
    end

    context 'リクエストがinvalid' do

      before do
        allow_any_instance_of(ApplicationController).to receive(:current_user)
                                                          .and_raise(ActiveRecord::RecordNotFound)
        get v1_user_path, headers:
      end

      it 'ステータスコードが404' do
        expect(response).to have_http_status(404)
      end
    end
  end

  describe 'POST /v1/user' do
    let(:user_params) { { user: { name: 'new_user', photo_url: 'https://example.com/photo.jpg' } } }
    let(:headers) { { 'Authorization' => "Bearer #{user.firebase_uid}" } }

    context 'リクエストがvalidな場合' do
      before do
        allow_any_instance_of(ApplicationController).to receive(:firebase_user)
                                                          .and_return({
                                                                        user_id: user.firebase_uid,
                                                                        email: user.email
                                                                      })
      end
    end
  end

  # describe 'POST /v1/user' do
    # context 'when the request is valid' do
    #   before do
    #     allow_any_instance_of(User).to receive(:save).and_return(true)
    #     post v1_user_path, params: user_params
    #   end
    #
    #   it 'creates a user and returns status code 200' do
    #     expect(response).to have_http_status(:success)
    #   end
    #
    #   it 'returns the user data' do
    #     expect(response.parsed_body).to include('name' => 'new_user')
    #   end
    # end

    # context 'when the request is invalid' do
    #   before do
    #     allow_any_instance_of(User).to receive(:save).and_return(false)
    #     allow_any_instance_of(User).to receive_message_chain(:errors, :full_messages)
    #       .and_return(['Invalid parameters'])
    #     post v1_user_path, params: user_params
    #   end
    #
    #   it 'returns status code 400' do
    #     expect(response).to have_http_status(:bad_request)
    #   end
    #
    #   it 'returns an error message' do
    #     expect(response.parsed_body).to eq('errors' => ['Invalid parameters'])
    #   end
    # end
  # end
end
