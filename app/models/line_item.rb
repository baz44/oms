class LineItem < ActiveRecord::Base
  belongs_to :order
  belongs_to :product

  validates_presence_of :quantity
  before_create :set_net_price

  private

  def set_net_price
    unless self.net_price
      self.net_price = self.product.net_price * self.quantity
    end
  end
end
