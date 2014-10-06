class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :status, default: 'draft'
      t.date :date, default: Time.now
      t.decimal :vat, precision: 5, scale: 2, default: 20.00
    end
  end
end
