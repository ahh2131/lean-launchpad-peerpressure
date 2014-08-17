json.product do
	json.id @product.id
	json.name @product.name
	json.price @product.price
	json.image_url @product.image_s3_url
end