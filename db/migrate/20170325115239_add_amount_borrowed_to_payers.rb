class AddAmountBorrowedToPayers < ActiveRecord::Migration
  def change
  	add_column :payers, :amt_borrowed, :float, precision: 5, scale: 2
  end
end
