class ProfileController < ApplicationController

	def index
	end
	
	def show
	  
	  if params[:id]
	  	@user_id = params[:id]
	  else
  		@user_id = session[:user_id]
   	  end
	  @user_info = User.find(@user_id)

#	  @saved_products = userSavedProducts(@user_id)
	#  @added_products = userAddedProducts(@user_id)
	  @shared_products = userSharedProducts(@user_id)

	  @following = Activity.where(:fromUser => @user_id, :activity_type => "follow").count
	  @followers = Activity.where(:toUser => @user_id, :activity_type =>"follow").count

	  @vigor = Activity.where(:toUser => @user_id, :activity_type => "seen").count
	  @vigor_array = Array.new(@vigor)

	  @lists = List.where(:user_id => @user_id).order("created_at desc").limit(5)
	  @products_for_each_list = []
	  @lists.each do |list|
	  	product_ids = Activity.where(:list_id => list.id, :activity_type => "add_to_list", :fromUser => @user_id)
	  	.order("created_at desc").limit(4).pluck(:product)
	  	products = []
	  	product_ids.each do |product_id|
	  		product = Product.find(product_id)
	  		products << product
	  	end
	  	@products_for_each_list << products
	  end

	  # 1 or 0 , depending on if user is a followed
	  @followed = isUserFollowed(@user_id)

	end

	def isUserFollowed(user_id)
		activity = Activity.where(:fromUser => session[:user_id], :activity_type => "follow")
		.where(:toUser => user_id).first
		if activity.nil?
			return 0
		else
			return 1
		end
	end

	def follow
		activity = Activity.new
		activity.fromUser = session[:user_id]
		activity.toUser = params[:user_to_follow]
		activity.activity_type = "follow"
		activity.save

		@user_info = User.find(params[:user_to_follow])
		@followers = Activity.where(:toUser => params[:user_to_follow], :activity_type =>"follow").count


		respond_to do |format|
 	      format.html
          format.js
        end
	end

	def unfollow
		activity = Activity.where(:fromUser => session[:user_id], :toUser => params[:user_to_unfollow])
		.where(:activity_type => "follow").first
		activity.destroy

		@user_info = User.find(params[:user_to_unfollow])
		@followers = Activity.where(:toUser => params[:user_to_unfollow], :activity_type =>"follow").count


		respond_to do |format|
 	      format.html
          format.js
        end
	end
	# all user saved or added
	def userSharedProducts(user_id)
		product_ids = Activity.where(:activity_type => ["save","add"], :fromUser => user_id).limit(100).pluck(:product)
		@products = Product.where(:id => product_ids)
		return @products
	end

	def userSavedProducts(user_id)
		product_ids = Activity.where(:activity_type => "save", :fromUser => user_id).limit(100).pluck(:product)
		@products = Product.where(:id => product_ids)
		return @products
	end

	def userAddedProducts(user_id)
		product_ids = Activity.where(:activity_type => "add", :fromUser => user_id).limit(100).pluck(:product)
		@products = Product.where(:id => product_ids)
		return @products
	end
end
