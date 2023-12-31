class V1::StoragesController < ApplicationController
  before_action :set_storage_and_members, only: %i[show update destroy]
  before_action :verify_owner, only: %i[update destroy]

  def index
    @storages = Storage.my_storages(current_user).order(created_at: :desc)
    @members = User.storage_members(@storages)
  end

  def show
    raise ActiveRecord::RecordNotFound unless @members.exists?(name: current_user.name)
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
    existing_member_names = @members.pluck(:name).reject { |name| name == current_user.name }
    request_member_names = storage_params[:members] || []
    delete_member_names = existing_member_names - request_member_names
    add_member_names = request_member_names - existing_member_names
    ActiveRecord::Base.transaction do
      @storage.update!({
                         name: storage_params[:name],
                         description: storage_params[:description],
                         image_url: storage_params[:image_url]
                       })
      delete_member_names.each do |name|
        user = User.find_by!(name:)
        UserStorage.find_by!(user: user, storage: @storage).destroy!
      end
      add_member_names.each do |name|
        user = User.find_by!(name:)
        UserStorage.create_member(user, @storage)
      end
    end
    render :show
  end

  def destroy
    @storage.destroy!
    render :show
  end

  private

  def set_storage_and_members
    @storage = Storage.find_by!(slug: params[:id])
    @members = User.storage_members(@storage)
  end

  def verify_owner
    is_owner = UserStorage.exists?(user: current_user, storage: @storage, role: :owner)
    raise ActiveRecord::AuthenticationError unless is_owner
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
