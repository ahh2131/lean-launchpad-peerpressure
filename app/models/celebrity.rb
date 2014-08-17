class Celebrity < ActiveRecord::Base
	has_many :celebrity_products
	has_many :products, through: :celebrity_products
end
