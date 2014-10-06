class CreateLineItems < ActiveRecord::Migration
  def change
    create_table :line_items do |t|
      t.integer :quantity
      t.decimal :net_price, precision: 5, scale: 2
      t.belongs_to :order
      t.belongs_to :product
    end
  end
end
