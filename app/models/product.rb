require "open-uri"
class Product < ActiveRecord::Base
	has_many :category_product, :foreign_key => 'product'
	has_many :categories, through: :category_product
	has_many :activities
	has_many :users, through: :activities
  has_many :lists, through: :activities

  has_attached_file :image_s3
  # Validate the attached image is image/jpg, image/png, etc
  validates_attachment_content_type :image_s3, :content_type => /\Aimage\/.*\Z/
  
  def picture_from_url(url)
    self.image_s3 = open(url)
  end

end
