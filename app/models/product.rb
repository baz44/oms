class Product < ActiveRecord::Base
  has_many :line_items
  has_many :orders, through: :line_items

  validates_uniqueness_of :name

  before_destroy :validate_orders

  private

  def validate_orders
    if !self.orders.empty?
      errors.add(:base, "Cannot delete a product that has been added to orders.")
      return false
    end
    return true
  end
end
