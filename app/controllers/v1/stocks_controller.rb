class V1::StocksController < ApplicationController

  before_action :set_storage_and_members
  before_action :set_stock, only: %i[show update destroy]

  def index
    @stocks = @storage.stocks.order(created_at: :desc)
  end

  def create
    stock            = @storage.stocks.build(stock_params)
    stock.created_by = current_user
    stock.updated_by = current_user

    stock.save!
    render json: stock
  end

  def show
    @stock = Stock.find params[:id]
  end

  def update
    @stock.update!({
                     name:              stock_params[:name],
                     item_count:        stock_params[:item_count],
                     image_url:         stock_params[:image_url],
                     description:       stock_params[:description],
                     price:             stock_params[:price],
                     unit_name:         stock_params[:unit_name],
                     purchase_location: stock_params[:purchase_location],
                     alert_threshold:   stock_params[:alert_threshold],
                     updated_by:        current_user
                   })
    render :show
  end

  def destroy
    @stock.destroy!
    render :show
  end

  private

  def stock_params
    params.require(:stock).permit(:name, :item_count, :image_url, :description, :price, :unit_name, :purchase_location, :alert_threshold, :is_favorite, :category_id)
  end

  def set_storage_and_members
    @storage = Storage.find_by!(slug: params[:storage_id])
    @members = User.storage_members(@storage)
    # メンバーしかアクセスできない
    raise ActiveRecord::RecordNotFound unless @members.exists?(name: current_user.name)
  end

  def set_stock
    @stock = Stock.find(params[:id])
  end
end
