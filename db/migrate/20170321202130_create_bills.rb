class CreateBills < ActiveRecord::Migration
  def change
    create_table :bills do |t|
      t.string :event
      t.text :description
      t.integer :amount
      t.string :location
      t.date :event_date
      t.references :group, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
