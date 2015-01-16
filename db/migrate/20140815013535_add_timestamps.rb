class AddTimestamps < ActiveRecord::Migration
  def change
  	add_column :celebrities, :created_at, :datetime
  	add_column :celebrities, :updated_at, :datetime
  	add_column :celebrity_products, :created_at, :datetime
  	add_column :celebrity_products, :updated_at, :datetime

  end
end
