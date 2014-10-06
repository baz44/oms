class Order < ActiveRecord::Base
  has_many :line_items
  has_many :status_transitions
  has_many :products, through: :line_items

  validates_inclusion_of :status, in: %w{draft placed paid cancelled}

  before_create :set_date
  validate :status_should_be_draft, on: :update

  def set_date
    self.date = Time.now
  end

  def status_should_be_draft
    errors.add(:base, "Cannot delete a product that has been added to orders.") if self.status != 'draft'
  end
end
