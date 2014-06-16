class ProfileController < ApplicationController

	def index
	end
	
	def show
	  
	  if params[:id]
	  	user_id = params[:id]
	  else
  		user_id = session[:user_id]
   	  end
	  @user_info = User.find(user_id)

	end

end
