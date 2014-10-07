class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :status, default: 'draft'
      t.date :order_date, default: Time.now
      t.float:vat, default: 20.00
    end
  end
end
