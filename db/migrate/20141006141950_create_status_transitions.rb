class CreateStatusTransitions < ActiveRecord::Migration
  def change
    create_table :status_transitions do |t|
      t.string :event
      t.string :from
      t.string :to
      t.timestamp :created_at
      t.belongs_to :order
    end
  end
end
