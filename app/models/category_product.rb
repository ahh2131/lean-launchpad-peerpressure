class CategoryProduct < ActiveRecord::Base
	self.table_name = "category_product"
	belongs_to :category, :foreign_key => 'category'
	belongs_to :product, :foreign_key => 'product'
end
