json.profile do
	json.id @user_info.id
	if current_user.id == @user_info.id
		json.me 1
	else
		json.me 0
	end
	json.name @user_info.name
	json.avatar @user_info.avatar.url
	json.followers @followers
	json.following @following
	json.followed @followed
	json.shared_products @shared_products.each do |product|
		json.id product.id
		json.name product.name
		json.price product.price
		json.image_url product.image_s3_url
	end
	json.lists @lists.zip(@products_for_each_list).each do |list, products|
		json.id list.id
		json.name list.title
		json.products products do |product|
			json.id product.id
			json.name product.name
			json.price product.price
			json.image_url product.image_s3_url
		end
	end
end