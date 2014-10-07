class LineItemsController < ApplicationController

  before_filter :get_order

  def create
    line_item = LineItem.new(line_item_params.merge(order: @order))
    if line_item.save
      render json: line_item.to_json, status: 201
    else
      render json: line_item.errors.to_json, status: 400
    end
  end

  def show
    line_item = LineItem.find(params[:id])
    render json: line_item.to_json
  end

  def index
    render json: LineItem.all
  end

  def update
    line_item = LineItem.find(params[:id])
    if line_item.update(line_item_params.merge(order: @order))
      render json: line_item.to_json, status: 200
    else
      render json: line_item.errors.to_json, status: 400
    end
  end

  def destroy
    line_item = LineItem.find(params[:id])
    if line_item.destroy
      render json: {}, status: 204
    else
      render json: line_item.errors.to_json, status: 400
    end
  end

  private

  def line_item_params
    params.require(:line_item).permit(:product_id, :order_id, :quantity, :net_price)
  end

  def get_order
    @order = Order.find(params[:order_id])
  end
end
