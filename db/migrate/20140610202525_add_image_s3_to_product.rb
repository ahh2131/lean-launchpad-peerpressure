class AddImageS3ToProduct < ActiveRecord::Migration
  def self.up
    add_attachment :products, :image_s3
  end

  def self.down
    remove_attachment :products, :image_s3
  end
end
