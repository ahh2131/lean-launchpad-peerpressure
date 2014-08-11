json.id @product.id
json.name @product.name
json.price @product.price
json.buy_url @product.buy_url
json.image_url @product.image_s3_url
json.retailer do
	json.id @retailer.id
	json.name @retailer_user.name
	json.products @other_products_from_retailer do |product|
		json.id product.id
		json.name product.name
		json.price product.price
		json.image_url product.image_s3_url
	end
end
json.similar_products @similar_products do |product|
	json.id product.id
	json.name product.name
	json.price product.price
	json.image_url product.image_s3_url
end
json.posted_by do
	json.id @original_poster.id
	json.name @original_poster.name
	json.avatar_url @original_poster.avatar.url
end
json.other_users @product_shared_by do |user|
	json.id user.id
	json.name user.name
	json.avatar_url user.avatar.url
end