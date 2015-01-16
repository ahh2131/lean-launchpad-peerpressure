class Category < ActiveRecord::Base
	has_many :category_product, :foreign_key => 'category_id'
	has_many :products, through: :category_product	
        has_many :posts, through: :category_products

end
