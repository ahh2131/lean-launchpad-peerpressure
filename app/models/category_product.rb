class CategoryProduct < ActiveRecord::Base
	self.table_name = "category_product"
	belongs_to :category, :foreign_key => 'category_id'
	belongs_to :product, :foreign_key => 'product_id'
end
