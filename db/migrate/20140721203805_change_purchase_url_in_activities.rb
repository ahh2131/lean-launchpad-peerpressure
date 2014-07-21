class ChangePurchaseUrlInActivities < ActiveRecord::Migration
  def change
  	change_column :activities, :purchase_url, :text
  end
end
