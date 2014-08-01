class AdminController < ApplicationController
	def index

		if current_user.admin != 1 || defined?(session[:admin_id]) == nil
			return redirect_to root_url
		end
		session[:admin_id] = current_user.id
	end

	def login
		current_user = User.find(params[:user_id])
		redirect_to root_url
	end


end
