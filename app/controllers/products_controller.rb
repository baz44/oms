class ProductsController < ApplicationController
  def create
    product = Product.new(product_params)
    if product.save
      render json: product.to_json, status: 201
    else
      render json: product.errors.to_json, status: 400
    end
  end

  def show
    product = Product.find(params[:id])
    render json: product.to_json
  end

  def index
    render json: Product.all
  end

  def update
    product = Product.find(params[:id])
    if product.update(product_params)
      render json: product.to_json, status: 200
    else
      render json: product.errors.to_json, status: 400
    end
  end

  def destroy
    product = Product.find(params[:id])
    if product.destroy
      render json: {}, status: 204
    else
      render json: product.errors.to_json, status: 400
    end
  end

  private

  def product_params
    params.require(:product).permit(:name, :net_price)
  end
end
