json.feed @discover_profiles.each_with_index do |profile, index|
	json.user do
		json.id profile.id
		json.name profile.name
		json.avatar_url profile.avatar.url
		json.followed @arrayFollowers[index.to_i]
	end
	json.products @products_for_each_user[index.to_i] do |product|
		json.id product.id
		json.name product.name
		json.price product.price
		json.image_url product.image_s3_url
	end
end
