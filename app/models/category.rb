class Category < ActiveRecord::Base
	has_many :category_product, :foreign_key => 'category'
	has_many :products, through: :category_product	
end
