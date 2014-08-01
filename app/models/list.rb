class List < ActiveRecord::Base
	validates :title, presence: true
	has_many :activities
	has_many :products, through: :activities
	has_many :users, through: :activities

end
