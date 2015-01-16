class Post < ActiveRecord::Base

  has_many :category_products, :foreign_key => 'post_id'
  has_many :categories, through: :category_products
  belongs_to :user, :foreign_key => 'user_id'
    
  has_attached_file :photo, :styles => { :medium => "300x300>", :thumb => "100x100>" },   :convert_options => { :all => '-auto-orient' } 

  validates_attachment_content_type :photo, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif", "text/html"]
  
  scope :filter_by_category, lambda{|category_ids| includes(:categories).where(:categories => {:id => category_ids})}

  validates :photo, presence: true

end
