module V1
  class UsersController < ApplicationController
    def show
      render json: current_user
    end

    def create
      user = User.new(
        name: user_params[:name],
        photo_url: user_params[:photo_url],
        firebase_uid: firebase_user['user_id'],
        email: firebase_user['email']
      )

      user.save!
      render json: user
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
