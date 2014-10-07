class StatusTransitionsController < ApplicationController

  before_filter :get_order

  def create
    status_transition = StatusTransition.new(status_transition_params.merge(order: @order))
    if status_transition.save
      render json: status_transition.to_json, status: 201
    else
      render json: status_transition.errors.to_json, status: 400
    end
  end

  def index
    render json: StatusTransition.all
  end

  private

  def status_transition_params
    params.require(:status_transition).permit(:event, :to)
  end

  def get_order
    @order = Order.find(params[:order_id])
  end
end
