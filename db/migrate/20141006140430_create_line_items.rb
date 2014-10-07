class CreateLineItems < ActiveRecord::Migration
  def change
    create_table :line_items do |t|
      t.integer :quantity
      t.float :net_price
      t.belongs_to :order
      t.belongs_to :product
    end
  end
end
