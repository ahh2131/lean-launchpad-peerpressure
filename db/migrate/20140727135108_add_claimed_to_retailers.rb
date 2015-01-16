class AddClaimedToRetailers < ActiveRecord::Migration
  def change
  	add_column :retailers, :claimed, :integer
  end
end
