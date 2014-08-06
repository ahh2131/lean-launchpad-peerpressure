class AdminController < ApplicationController
	before_action :require_admin
	def index
		@count = Activity.where(:confirmed => -1).count
	end

	def login
		current_user = User.find(params[:user_id])
		redirect_to root_url
	end

	def purchaseConfirmation
		@purchase = Activity.where(:confirmed => -1).order("created_at desc").first
		@count = Activity.where(:confirmed => -1).count
		if !@purchase.nil?
			session[:activity_id] = @purchase.id
			@product = Product.find(@purchase.product_id)
		end
	end

	def confirmed
		purchase = Activity.find(session[:activity_id])
		product = Product.find(purchase.product_id)

		if params[:option].to_i == -1
			purchase.confirmed = -2
		elsif params[:option].to_i == 0
			purchase.confirmed = 0
		else
			purchase.confirmed = 1
			if params[:keyword_1] != ""
				keyword = Keyword.new
				keyword.word = params[:keyword_1]
				keyword.retailer_id = product.retailer_id
				keyword.save
			end
			if params[:keyword_2] != ""
				keyword = Keyword.new
				keyword.word = params[:keyword_2]
				keyword.retailer_id = product.retailer_id
				keyword.save
			end
			if params[:keyword_3] != ""
				keyword = Keyword.new
				keyword.word = params[:keyword_3]
				keyword.retailer_id = product.retailer_id
				keyword.save
			end
			if params[:keyword_4] != ""
				keyword = Keyword.new
				keyword.word = params[:keyword_4]
				keyword.retailer_id = product.retailer_id
				keyword.save
			end
			if params[:keyword_5] != ""
				keyword = Keyword.new
				keyword.word = params[:keyword_5]
				keyword.retailer_id = product.retailer_id
				keyword.save
			end
		end
		purchase.save

		session.delete(:activity_id)
		redirect_to purchase_confirmation_path
	end

	def receipt
	end

	private

	def require_admin
	  if current_user.admin != 1 || defined?(session[:admin_id]) == nil
		return redirect_to root_url
	  end
	  session[:admin_id] = current_user.id
	end
end
