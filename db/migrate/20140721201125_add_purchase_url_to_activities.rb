class AddPurchaseUrlToActivities < ActiveRecord::Migration
  def change
 	 add_column :activities, :purchase_url, :string
  end
end
