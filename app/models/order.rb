class Order < ActiveRecord::Base
  has_many :line_items
  has_many :status_transitions
  has_many :products, through: :line_items

  validates_inclusion_of :status, in: %w{draft placed paid canceled}
  validate :status_should_be_draft, on: :update

  before_create :set_date, :set_status

  private

  def set_date
    self.order_date = Time.now
  end

  def set_status
    self.status = "draft"
  end

  def status_should_be_draft
    errors.add(:base, "Cannot delete a product that has been added to orders.") if self.status != 'draft'
  end
end
