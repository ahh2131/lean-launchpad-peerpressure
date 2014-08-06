class AddReceiptToActivities < ActiveRecord::Migration
	def self.up
	  add_attachment :activities, :receipt
	end

	def self.down
	  remove_attachment :activities, :receipt
	end
end
