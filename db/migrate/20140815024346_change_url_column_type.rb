class ChangeUrlColumnType < ActiveRecord::Migration
  def change
 	 change_column :celebrity_products, :url, :text
  end
end
