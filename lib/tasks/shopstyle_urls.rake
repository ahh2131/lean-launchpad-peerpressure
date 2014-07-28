namespace :shopstyle_urls do
  desc "gets product urls using shopstyle urls (important to make sure products in db are unique)"
  task get_product_urls: :environment do

  	pageNumber = 10
  	agent = Mechanize.new
  	while pageNumber != 0
  		products = Product.where(:extractor_url => nil).page(pageNumber).per(1000)
  		if products.count != 0
  			products.each do |product|
  				page = agent.get(product.buy_url) 
  				redirect_url = 0 	
  				begin			
  					redirect_url = page.parser.at('meta[http-equiv="refresh"]')['content'][/url=(.+)/, 1]
  				rescue
  					redirect_url = 0
  				end

  				if redirect_url != 0
  					begin
  						page = agent.get(redirect_url)
  					rescue
  						next
  					end
  					redirect_url = 0
	  				begin			
	  					redirect_url = page.parser.at('meta[http-equiv="refresh"]')['content'][/url=(.+)/, 1]
	  				rescue
	  					redirect_url = 0
	  				end# add code back here
  					product.extractor_url = page.uri.to_s
  					p page.uri.to_s

  				else
  					product.extractor_url = page.uri.to_s
  					p page.uri.to_s
  				end
  				product.save
  			end
  			pageNumber = pageNumber + 1
  		else
  			pageNumber = 0
  		end
  	end
  end

      # def method_missing(meth,*args)
      # 		p "method missing bro"
      #   	return 0
      #   end

end

  					# if redirect_url != 0
  					# 	page = agent.get(redirect_url)
  					# else
  					# 	product.extractor_url = page.uri.to_s
  					# end