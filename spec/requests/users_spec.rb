# rubocop:disable all
require 'rails_helper'

RSpec.describe 'Api::V1::Users', type: :request do
  let(:firebase_user) { { user_id: 1, email: 'hoge@hoge.com' } }
  let(:user_params) { { user: { name: 'new_user', photo_url: 'https://example.com/photo.jpg' } } }

  before do
    allow_any_instance_of(ApplicationController).to receive(:verify_id_token).and_return(true)
    allow_any_instance_of(ApplicationController).to receive(:firebase_user).and_return(firebase_user)
  end

  describe 'POST /api/v1/user' do
    context 'when the request is valid' do
      before do
        allow_any_instance_of(User).to receive(:save).and_return(true)
        post v1_user_path, params: user_params
      end

      it 'creates a user and returns status code 200' do
        expect(response).to have_http_status(:success)
      end

      it 'returns the user data' do
        expect(response.parsed_body).to include('name' => 'new_user')
      end
    end

    context 'when the request is invalid' do
      before do
        allow_any_instance_of(User).to receive(:save).and_return(false)
        allow_any_instance_of(User).to receive_message_chain(:errors, :full_messages)
          .and_return(['Invalid parameters'])
        post v1_user_path, params: user_params
      end

      it 'returns status code 400' do
        expect(response).to have_http_status(:bad_request)
      end

      it 'returns an error message' do
        expect(response.parsed_body).to eq('errors' => ['Invalid parameters'])
      end
    end
  end
end
