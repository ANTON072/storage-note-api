module V1
  class UsersController < ApplicationController
    def show
      if current_user
        render json: current_user
      else
        render json: { errors: 'user not found' },
               status: :not_found
      end
    end

    def create
      params = {
        name: user_params[:name],
        photo_url: user_params[:photo_url],
        firebase_uid: firebase_user['user_id'],
        email: firebase_user['email']
      }
      user = User.new(params)
      if user.save
        render json: user
      else
        render json: { errors: user.errors.full_messages },
               status: :bad_request
      end
    end

    def update
      current_user.update!({ photo_url: user_params[:photo_url] })
      render json: current_user
    end

    private

    def user_params
      params.require(:user).permit(:name, :photo_url)
    end
  end
end

