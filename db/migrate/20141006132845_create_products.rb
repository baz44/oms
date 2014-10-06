class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name
      t.decimal :net_price, precision: 5, scale: 2
    end
  end
end
