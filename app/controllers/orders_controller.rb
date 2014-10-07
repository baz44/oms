class OrdersController < ApplicationController
  def create
    order = Order.new(order_params)
    if order.save
      render json: order.to_json, status: 201
    else
      render json: order.errors.to_json, status: 400
    end
  end

  def show
    order = Order.find(params[:id])
    render json: order.to_json
  end

  def index
    render json: Order.all
  end

  def update
    order = Order.find(params[:id])
    if order.update(order_params)
      render json: order.to_json, status: 200
    else
      render json: order.errors.to_json, status: 400
    end
  end

  def destroy
    order = Order.find(params[:id])
    if order.destroy
      render json: {}, status: 204
    else
      render json: order.errors.to_json, status: 400
    end
  end

  private

  def order_params
    params.require(:order).permit(:order_date, :vat)
  end
end
