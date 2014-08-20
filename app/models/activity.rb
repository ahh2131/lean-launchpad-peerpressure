class Activity < ActiveRecord::Base
	validates :activity_type, presence: true
	# all activity_types
	validate :add_to_list_validator, :save_validator, :list_validator,
	 :add_validator, :follow_validator, :seen_validator

	belongs_to :user, :foreign_key => 'fromUser'
	belongs_to :product
	belongs_to :list

	has_attached_file :receipt
	validates_attachment_content_type :receipt, :content_type => ["text/html"]

	def add_to_list_validator
		if activity_type == "add_to_list"
			# checks for missing fields and missing product for this activity type
			if fromUser.nil? || product_id.nil? || list_id.nil? || product.nil?
				errors.add(:add_to_list, "missing fields!")
				return false
			end
		end
		return true
	end

	def save_validator
		if activity_type == "save"
			if fromUser.nil? || product_id.nil? || product.nil?
				errors.add(:save, "missing fields!")
				return false
			end
		end
	end

	def list_validator
		if activity_type == "list"
			if fromUser.nil? || list_id.nil?
				errors.add(:list, "missing fields!")
				return false
			end
		end
	end

	def add_validator
		if activity_type == "add"
			if fromUser.nil? || product_id.nil? || product.nil?
				errors.add(:add, "missing fields!")
				return false
			end
		end
	end

	def follow_validator
		if activity_type == "follow"
			if fromUser.nil? || toUser.nil?
				errors.add(:follow, "missing fields!")
				return false
			end
			from = User.where(:id => toUser).count
			if from == 0
				errors.add(:follow, "No id of user to follow")
				return false
			end
		end
	end

	def seen_validator
		if activity_type == "seen"
			if fromUser.nil? || product_id.nil? || product.nil?
				errors.add(:seen, "missing fields!")
				return false
			end
			activity = Activity.where(:activity_type => "seen", :product_id => product_id)
			.where(:fromUser => fromUser, :toUser => toUser).count
			if activity != 0
				errors.add(:seen, "user already saw this product")
				return false
			end
		end
	end

end
