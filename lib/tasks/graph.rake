namespace :graph do
  desc "creates a json file with fake data for graph"
  task dataInput: :environment do
    size = 100
    output = {:product_relations => []}
    products = ('1'...size.to_s).to_a
    inner_products = ('2'...size.to_s).to_a
    for product1 in products
      for product2 in inner_products
          
        views = rand(1000)
        shares = views - rand(views)
        purchases = shares - rand(shares) 
        output[:product_relations].append({:product1 => product1, :product2 => product2, :views => views, :purchases => purchases, :shares => shares})
      end
      inner_products.shift
    end 
    File.open("/home/andy/productFeedGraph/data.json","w") do |f|
      f.write(output.to_json)
    end
  end

end
