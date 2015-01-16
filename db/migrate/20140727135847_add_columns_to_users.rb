class AddColumnsToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :active, :integer
  	add_column :users, :retailer_id, :integer
  	add_column :users, :user_type, :integer

  end
end
