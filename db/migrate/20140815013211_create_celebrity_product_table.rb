class CreateCelebrityProductTable < ActiveRecord::Migration
  def change
    create_table :celebrity_products do |t|
    	t.string :url
    	t.string :source_url
    	t.integer :celebrity_id
    	t.integer :product_id
    end
  end
end
