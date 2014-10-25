namespace :kimono do
  desc "collects new coolspotter actresses and products"
  task coolspotters: :environment do
	response = open('https://www.kimonolabs.com/api/8rhuxszw?apikey=S3E94UjxZhfTbA8BvFcycIcpeWMRwwit')  	
	actresses = JSON(response.read)
	actresses = actresses["results"]["collection1"]
	splitter = "actresses/"
	for actress in actresses
          
	  # if name is not in celebrities, add it
	  url_name = actress["name"]["href"].split(splitter)[1]
          check = Celebrity.where(name: actress["name"]["text"]).first
          if check.nil?
            celebrity = Celebrity.new
            celebrity.name = actress["name"]["text"]
            celebrity.celebrity_type = "actress"
            user = User.new
            user.name = actress["name"]["text"]
            user.email = url_name + "@vigme.com"
	    user.password = "vigmeadmin"
	    user.user_type = 3
            user.gender = "F"
	    image_url = getCelebImageUrl(url_name)
	    user.avatar = image_url
	    user.save
            celebrity.user_id = user.id
	    celebrity.save
            celebrity_id = celebrity.id
	  else 
            celebrity_id = check.id
          end
         
	  # if there is user_id get it!
 	  if check.user_id == nil
	    user = User.new
            user.name = actress["name"]["text"]
            user.email = url_name + "@vigme.com"
	    user.password = "vigmeadmin"
	    user.user_type = 3
            user.gender = "F"
	    image_url = getCelebImageUrl(url_name)
	    user.avatar = image_url
	    user.save
            check.user_id = user.id
	    check.save
	  end
	  # get name from url, use to add products found with kimono api
	  p celebrity_id.to_s + " - "  + url_name
          getProducts(url_name, celebrity_id)


	  # associate products with 
	end
  end

  def getCelebImageUrl(url_name)
     image_response = open("https://www.kimonolabs.com/api/5e3zlo58?apikey=S3E94UjxZhfTbA8BvFcycIcpeWMRwwit&kimpath2=" + url_name)
     image_json = JSON(image_response.read)
     image_url = image_json["results"]["collection1"][0]["image"]["src"]         
     return image_url
  end

  def getProducts(celeb_url_name, celeb_id)
    agent = Mechanize.new
    agent.follow_meta_refresh = true
    url = "https://www.kimonolabs.com/api/8crbjpje?apikey=S3E94UjxZhfTbA8BvFcycIcpeWMRwwit&kimpath2=" + celeb_url_name
    response = open(url)
    json = JSON(response.read)
    products = json["results"]["collection1"]
    count = 0
    check = 0
    while count < products.count && check != 1
      product_url = products[count]["image"]["href"]
     skip = 0
     begin
        @page = agent.get(product_url) 
     rescue
        skip = 1
     end
     if skip != 1
      check = CelebrityProduct.where(:url => @page.uri.to_s, :celebrity_id => celeb_id).count
      if check == 0
        celeb_product = CelebrityProduct.new
        celeb_product.url = @page.uri.to_s
        celeb_product.source_url = "http://coolspotters.com"
        celeb_product.celebrity_id = celeb_id
        product_id = getProduct(@page.uri.to_s, products[count]["name"]["text"], products[count]["name"]["href"])
        celeb_product.product_id = product_id
        celeb_product.save
      end
 
      
     end
      count = count + 1
    end
  end


  def getProduct(product_url, name, image_url)
    check = Product.where(extractor_url: product_url).first
    if check.nil?
      product = Product.new
      product.extractor_url = product_url
      product.buy_url = product_url
      product.source = "www.coolspotters.com"
      product.name = name
      product.image_s3 = getImageUrl(image_url)
      product.retailer_id = getRetailer(product_url)
      product.save
      product.image_s3_url = product.image_s3.url
      product.save
      return product.id
    else 
      return check.id
    end
  end

  def getImageUrl(image_url)
    base_url = "https://www.kimonolabs.com/api/32m0wj52?apikey=S3E94UjxZhfTbA8BvFcycIcpeWMRwwit&kimpath2="
    path = image_url.split("clothing/")[1].chomp("/")
    p path
    response = open(base_url + path)
    json = JSON(response.read)
    return json["results"]["collection1"][0]["image"]["src"]
  end

  def getRetailer(product_url)
    name = product_url.split(".")[1]
    url = name + ".com"
    retailer = Retailers.where(url: url).first
    if !retailer.nil?
      return retailer.id
    else
      return 0
    end
  end




end
