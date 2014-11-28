namespace :update do
  desc "checks if a product is available , set available to 1 or 0"
  task celebrity_products: :environment do
     
    products = CelebrityProduct.where(available: -1).all
    for product in products
       url = product.url
       if url.split(".com").count == 1 || url.split(".com/") == 1
         product.available = 0
       end 
      skip = 0
      begin
        response = open(product.url)
      rescue	
	skip = 1
      end
      if skip != 0
       html = response.read
       array = ["Out of stock", "Unavailable", "Page not found", "Sold out"]
       for word in array
         if html.include? word
           product.available = 0
         end
       end
      end

       if product.available != 0
	 # product.available == 1
       end

       product.save
 
    end
    
  end

end
