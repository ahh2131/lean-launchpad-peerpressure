class FixProductColumnName < ActiveRecord::Migration
  def change
  	rename_column :activities, :product, :product_id
  end
end
