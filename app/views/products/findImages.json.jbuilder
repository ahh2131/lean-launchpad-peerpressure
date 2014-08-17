if @exists.nil?
	json.product do 
		json.url session[:product_link]
		json.price session[:product_price]
		json.images @image_array do |image|
			json.url image
		end
	end
else
	json.message "Product already exists!"
	json.error "1"
	json.product do
		json.id @exists
	end
end