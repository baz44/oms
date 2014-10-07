class LineItem < ActiveRecord::Base
  belongs_to :order
  belongs_to :product

  validates_presence_of :quantity, :order_id, :product_id
  validate :status_should_be_draft, on: :update

  before_create :set_net_price

  private

  def set_net_price
    unless self.net_price
      self.net_price = self.product.net_price * self.quantity
    end
  end

  def status_should_be_draft
      puts self.order.inspect
    errors.add(:base, "Cannot update an order if order status is not draft") if self.order.status != 'draft'
  end
end
