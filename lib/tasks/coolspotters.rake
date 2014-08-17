namespace :coolspotters do
  desc "Gets Celebs from a coolspotters url"
  task getCelebs: :environment do
  	page = 1
  	while page <= 77 do
	  	url = "http://coolspotters.com/celebrities/musicians?grid=spots&page=1" + page.to_s
	  	@doc = Nokogiri::HTML(open(url))
	  	@doc.css("a[class='listing-profile-name']").each_with_index do |name, index|
	  		fixed_name = name.text.parameterize
	  		fixed_name = fixed_name.tr('-', ' ')
	  		fixed_name = fixed_name.split.map(&:capitalize).join(' ')
	  		count = Celebrity.where(:name => fixed_name).count
	  		if count == 0
		  		celeb = Celebrity.new
		  		celeb.name = fixed_name
		  		celeb.celebrity_type = "musician"
		  		celeb.save
	  		end
	  	end 
	  	page = page + 1
	end
  end

  def getCelebType(doc, index)
  	p doc.css("div[class='listing-plate-updated'] span")[index]
  	string = doc.css("div[class='listing-plate-updated'] span")[index].text
  	string2 = string.slice(string.index('(')..string.index(')'))
  	string2[0] = ''
  	string2[string2.length-1] = ''
  	return string2.downcase
  end

  desc "From Celebs clothing shop pages, grab every page of products"
  task getProductUrls: :environment do
  	celeb_type = "musician"
  	agent = Mechanize.new
  	agent.follow_meta_refresh = true
  	celebs = Celebrity.where(:celebrity_type => celeb_type)
  	.order("created_at asc").page(20).per(2)
  	celebs.each do |celeb|
  		name = celeb.name.tr(' ', '-')
  		p name
  		url = "http://coolspotters.com/musicians/" + name + "/shop/clothing"
  		@doc = Nokogiri::HTML(open(url))
  		pages = getNumberOfProductPages(@doc)
  		count = 1
  		check = 0
  		while count <= pages && check == 0 do
  			new_url = url + "?page=" + count.to_s
  			@doc = Nokogiri::HTML(open(new_url))
  			@doc.css("a[class='gg-buyit']").each do |product|
  				# mechanize product["href"]
  				begin
	  				@page = agent.get(product["href"])
	  				p @page.uri.to_s
	  			rescue
	  				skip = 1
	  			end
	  			if skip != 1
	  				check = CelebrityProduct.where(:url => @page.uri.to_s, :celebrity_id => celeb.id).count
	  				if check == 0
		  				product = CelebrityProduct.new
		  				product.url = @page.uri.to_s
		  				product.source_url = "http://coolspotters.com"
		  				product.celebrity_id = celeb.id
		  				product.save
	  				end
	  			end
  			end
  			count = count + 1
  		end
  	end
  end

  def getNumberOfProductPages(doc)
  	number = doc.css("a[class='page']").count
  	if number != 0
  		return pages = doc.css("a[class='page']")[number-2].text.to_i
  	else
  		return 1
  	end
  end

  desc "Compare (with little computations) affiliate products with celeb products"
  task getAffiliateProducts: :environment do
  	products = CelebrityProduct.where("product_id IS NULL").order("created_at desc").all
  	products.each do |product|
  		url = stripProductLink(product.url)
  		retailer = Retailers.where("url LIKE ?", url).first
  		if !retailer.nil?
  			match = Product.where(:retailer_id => retailer.id)
  			.where("extractor_url LIKE ?", product.url).first
  			if !match.nil?
  				product.product_id = match.id
  				product.save
  			end
  		end
  	end

  end

  def stripProductLink(product_link)
  	if product_link.include? ".com"
    	new_str = product_link.slice(0..(product_link.index('.com')))
    	new_str.slice! "www."
    	new_str.slice! "http://"
    	new_str.slice! "https://"
    	new_str = new_str + "com"
    elsif product_link.include? ".net"
    	new_str = product_link.slice(0..(product_link.index('.net')))
	    new_str.slice! "www."
	    new_str.slice! "http://"
	    new_str.slice! "https://"
	    new_str = new_str + "net"
	end
    return new_str
  end

end
