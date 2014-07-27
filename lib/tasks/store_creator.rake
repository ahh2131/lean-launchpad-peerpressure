namespace :store_creator do

	desc "Creates a store account in user for all retailers that do not have one"
	task retailers: :environment do
		retailer_list = Retailers.all
		retailer_list.each do |retailer|
			user = User.where(:retailer_id => retailer.id).first
			if user.nil?
				new_user = User.new
				new_user.name = retailer.name
				new_user.user_type = 2
				new_user.active = 0
				new_user.retailer_id = retailer.id
				new_user.save
			end
		end

	end

end
