json.profile_page @page
json.feed @products.each do |products|
        json.products products do |product|
		json.id product.id
		json.name product.name
		json.price product.price
		json.image_url product.image_s3_url
	end
end
