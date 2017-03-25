class AddStatusToPayer < ActiveRecord::Migration
  def change
    add_column :payers, :status, :boolean, default: false
  end
end
