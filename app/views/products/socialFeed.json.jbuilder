json.profile_page @page
json.product_page @product_page
json.feed @social_feed_profiles.zip(@products_for_each_user).each do |profile, products|
	json.user do
		json.id profile.id
		json.name profile.name
		json.avatar_url profile.avatar.url
	end
	json.products products do |product|
		json.id product.id
		json.name product.name
		json.price product.price
		json.image_url product.image_s3_url
	end
end
