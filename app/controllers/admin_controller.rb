class AdminController < ApplicationController
	def index
		user = User.find(session[:user_id])

		if user.admin != 1 || defined?(session[:admin_id]) == nil
			return redirect_to root_url
		end
		session[:admin_id] = session[:user_id]
	end

	def login
		session[:user_id] = params[:user_id]
		user = User.find(session[:user_id])
		session[:user_image] = user.avatar.url

		redirect_to root_url
	end


end
