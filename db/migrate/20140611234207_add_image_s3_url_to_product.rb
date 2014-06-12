class AddImageS3UrlToProduct < ActiveRecord::Migration
  def self.up
    add_column :products, :image_s3_url, :string
  end

  def self.down
    remove_column :products, :image_s3_url
  end
end
