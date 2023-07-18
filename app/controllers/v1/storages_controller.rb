class V1::StoragesController < ApplicationController

  before_action :verify_owner, only: %i[show update destroy]

  def index
    @storages = Storage.owner_storages(current_user)
    @members = User.storage_members_for_multiple_storages(@storages)
  end

  def show
  end

  def create
    storage = Storage.new(
      name: storage_params[:name],
      description: storage_params[:description],
      image_url: storage_params[:image_url]
    )
    members_names = storage_params[:members] || []

    ActiveRecord::Base.transaction do
      storage.save!
      UserStorage.create_owner(current_user, storage)
      members_names.each do |name|
        user = User.find_by!(name:)
        UserStorage.create_member(user, storage)
      end
    end

    render json: storage
  end

  def update
    @storage.update!(storage_params)
    render :show
  end

  def destroy
    @storage.destroy!
    render :show
  end

  private

  def verify_owner
    @storage = Storage.find_by(slug: params[:id])
    @members = User.storage_members_for_multiple_storages(@storage)
    is_owner = UserStorage.exists?(user: current_user, storage: @storage, role: :owner)
    raise ActiveRecord::RecordNotFound unless is_owner
  end

  def storage_params
    params.require(:storage).permit(
      :name,
      :description,
      :image_url,
      members: []
    )
  end

end
