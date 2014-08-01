class FixProductCategoryColumn < ActiveRecord::Migration
  def change
  	rename_column :category_product, :product, :product_id
  	rename_column :category_product, :category, :category_id

  end
end
