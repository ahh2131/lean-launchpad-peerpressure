class AddConfirmedToActivities < ActiveRecord::Migration
  def change
  	add_column :activities, :confirmed, :integer
  end
end
