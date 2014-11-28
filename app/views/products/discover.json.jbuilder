json.feed @discover_profiles.zip(@products_for_each_user).each_with_index do |profile, products, index|
 	json.user do
		json.id profile.id
		json.name profile.name
		if profile.avatar.exists?
                  json.avatar_url profile.avatar.url
                else
                  json.avatar_url ""
                end
		json.followed @arrayFollowers[index.to_i]
	end
	json.products products.each do |product|
		json.id product.id
		json.name product.name
		json.price product.price
		json.image_url product.image_s3_url
	end
end
