class V1::StoragesController < ApplicationController

  before_action :verify_owner, only: %i[show update destroy]

  def index
    @storages = Storage.owner_storages(current_user)
    @members = User.storage_members_for_multiple_storages(@storages)
  end

  def show
    @members = User.storage_members_for_multiple_storages(@storage)
  end

  def create
    storage = Storage.new(
      name: storage_params[:name],
      description: storage_params[:description],
      image_url: storage_params[:image_url]
    )
    members_names = storage_params[:members] || []

    ActiveRecord::Base.transaction do
      UserStorage.create_owner(current_user, storage)
      members_names.each do |name|
        user = User.find_by!(name:)
        UserStorage.create_member(user, storage)
      end
      storage.save!
    end

    render json: storage
  end

  def update

  end

  def destroy

  end

  private

  def verify_owner
    @storage = Storage.find_by(slug: params[:id])
    owners = Storage.owner_storages(current_user)
    raise ActiveRecord::RecordNotFound unless owners.include?(@storage)
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
