class Activity < ActiveRecord::Base
	belongs_to :user, :foreign_key => 'fromUser'
	belongs_to :product
	belongs_to :list
end
