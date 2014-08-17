class CelebrityProduct < ActiveRecord::Base
	belongs_to :celebrity
	belongs_to :product

end
