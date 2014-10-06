class StatusTransition < ActiveRecord::Base
  belongs_to :order

  before_save :check_status_transition
  before_save :change_from_status

  after_save :update_order_status

  validates_inclusion_of :to, in: %w{draft placed paid canceled}

  private

  def check_status_transition
    return true if ['draft', 'placed'].include?(self.order.status) && self.to == 'canceled' && !self.event.blank?
    return true if self.order.status == 'draft' && self.to == 'placed'
    return true if self.order.status == 'placed' && self.to == 'paid'
    return false
  end

  def change_from_status
    self.from = self.order.status
  end

  def update_order_status
    self.order.status = self.to
    self.order.save(validate: false)
  end
end
