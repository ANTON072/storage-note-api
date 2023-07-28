class V1::StocksController < ApplicationController
  before_action :set_storage_and_members
  before_action :set_stock, only: %i[show update destroy favorite unfavorite increment decrement]
  before_action :verify_owner, only: %i[destroy]
  before_action :verify_creator, only: %i[destroy]

  def index
    @stocks = @storage.stocks.order(created_at: :desc)
  end

  def show
    @stock = Stock.find params[:id]
  end

  def create
    stock            = @storage.stocks.build(stock_params)
    stock.created_by = current_user
    stock.updated_by = current_user

    stock.save!
    render json: stock
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

  def favorite
    @stock.update!(is_favorite: true)
    render :show
  end

  def unfavorite
    @stock.update!(is_favorite: false)
    render :show
  end

  def increment
    item_count = params[:item_count].to_i
    if item_count <= 0
      render json: { error: 'item_countが無効です' }, status: :bad_request
      return
    end

    new_item_count = @stock.item_count + item_count
    @stock.update!(item_count: new_item_count)
    render :show
  end

  def decrement
    item_count = params[:item_count].to_i
    if item_count <= 0
      render json: { error: 'item_countが無効です' }, status: :bad_request
      return
    end

    new_item_count = @stock.item_count - item_count
    if new_item_count.negative?
      render json: { error: 'item_countが無効です' }, status: :bad_request
      return
    end

    @stock.update!(item_count: new_item_count)
    render :show
  end

  private

  def stock_params
    params
      .require(:stock)
      .permit(:name, :item_count, :image_url, :description, :price, :unit_name, :purchase_location,
              :alert_threshold, :is_favorite, :category_id)
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

  def verify_owner
    is_owner = UserStorage.exists?(user: current_user, storage: @storage, role: :owner)
    raise ActiveRecord::AuthenticationError unless is_owner
  end

  def verify_creator
    is_creator = @stock.created_by == current_user
    raise ActiveRecord::AuthenticationError unless is_creator
  end
end
