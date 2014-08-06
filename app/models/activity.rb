class Activity < ActiveRecord::Base
	belongs_to :user, :foreign_key => 'fromUser'
	belongs_to :product
	belongs_to :list

	has_attached_file :receipt
	validates_attachment_content_type :receipt, :content_type => ["text/html"]

end
