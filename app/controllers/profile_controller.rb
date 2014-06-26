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

	  @saved_products = userSavedProducts(@user_id)
	  @added_products = userAddedProducts(@user_id)
	end

	def follow
		activity = Activity.new
		activity.fromUser = session[:user_id]
		activity.toUser = params[:user_to_follow]
		activity.activity_type = "follow"
		activity.save
		respond_to do |format|
 	      format.html
          format.js
        end

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
