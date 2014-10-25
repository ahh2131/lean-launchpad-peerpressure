require 'open-uri'

namespace :viglink do
  desc "test how many celebrity products can have affiliate links"
  task tester: :environment do
    products = CelebrityProduct.all
    viglink_base = "http://api.viglink.com/api/click?reaf=true&key=4e38052ea068842961938d180d3fbeaa&loc=http%3A%2F%2Fvigme.com&format=txt&out="
    count = 0
    productCount = 1
    for product in products
      final_url = viglink_base + product.url
      response = nil
      response = open(final_url)
      print response.read
      print "\n" + product.url
      if response.read == product.url
        count = count + 1
      end
      if count%10 == 0
        print "Percentage:" + (count/productCount).to_s + "\n"
      end     
      productCount = productCount + 1
    end
    print count + "\n"
  end
end
