class Post < ActiveRecord::Base

  has_attached_file :photo, :styles => { :medium => "300x300>", :thumb => "100x100>" },   :convert_options => { :all => '-auto-orient' } 

  validates_attachment_content_type :photo, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif", "text/html"]
  
  validates :photo, presence: true

end
