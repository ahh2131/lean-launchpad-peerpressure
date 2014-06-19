require "net/http"

namespace :s3_import do
  desc "Looks at all products in Product table and creates
	image attachment url for s3 based on photo directory"
  task import_from_fasheebo: :environment do
	
	pageNumber = 1
	while pageNumber != 0 do
	  products = Product.where(:image_s3_url => nil)
	  .where(:image_processed => 1).where("image_folder != ?", 0)
	  .where(:image_result => 0)
	  .page(pageNumber).per(1000)
	  if products.count != 0
	    #add image to s3 and increment page
	    products.each do |product|
                url = "http://www.vigme.com/photos/"
                path = product.image_folder.to_s + "/" + product.id.to_s + ".jpg"
                url = url + path
#                p url 
                urlCheck = URI.parse(url)
                req = Net::HTTP.new(urlCheck.host, urlCheck.port)
                res = req.request_head(urlCheck.path)
                if res.code != "404"
		            product.image_s3 = url
		            # add datetimes and delete old images
					product.ftp_transfer_processed = 1
					product.ftp_transfer_datetime = Time.now
					product.image_s3_url = product.image_s3.url
					product.ftp_transfer_deleted_source = 1
					product.ftp_transfer_deleted_source_datetime = Time.now
					product.save
#					p "Product Id:   " + product.id.to_s
					p "Amazon s3 URL:" + product.image_s3.url.to_s
					path_to_file = "/var/www/vigme.com/photos/" + path
					File.delete(path_to_file) if File.exist?(path_to_file)
				end
        end
	    pageNumber = pageNumber + 1
	  else
	    pageNumber = 0
	  end 

    end 	
  end

end
