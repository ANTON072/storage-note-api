class V1::CategoriesController < ApplicationController

  before_action :set_storage

  def index
    @categories = @storage.categories.order(id: :asc)
  end

  def create

  end

  def update

  end

  def destroy

  end

  private

  def set_storage
    @storage = Storage.find_by!(slug: params[:storage_id])
  end

end
