class AddPostIdToCategoryProduct < ActiveRecord::Migration
  def change
    add_column :category_product, :post_id, :integer
  end
end
