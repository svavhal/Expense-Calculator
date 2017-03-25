class CreatePayers < ActiveRecord::Migration
  def change
    create_table :payers do |t|
      t.references :group, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.references :bill, index: true, foreign_key: true
      t.integer :amount
      t.timestamps null: false
    end
  end
end
