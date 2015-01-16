class ProfileController < ApplicationController
	layout "signup", :only => [ :step_two, :step_three]
skip_before_filter  :verify_authenticity_token

        def getMutualFriendsImages
          friends = params[:friends].split("X")
          p friends
          @friends = []
          friends.each do |friend|
            user = User.where(uid: friend).first
            if !user.nil?
              @friends << user
            end
          end
        end
  
	# api auth key
	def getAuthenticationToken
		potential_user = User.where(:email => params[:user_email]).first
		if params[:user_password] != nil && !potential_user.nil?
                  if potential_user.valid_password?(params[:user_password])
			@user = potential_user
	          end
                end
		respond_to do |format|
			format.json
		end
	end

	# api sign up
	def api_signup
		user = User.new
		user.email = params[:email]
		user.password = params[:password]
		user.name = params[:name]
		user.gender = params[:gender] if !params[:gender].nil?
		user.oauth_token = params[:oauth_token] if !params[:oauth_token].nil?
		user.oauth_expires_at = params[:oauth_expires_at] if !params[:oauth_expires_at].nil?
                user.uid = params[:uid] if !params[:uid].nil?		
		if !params[:avatar].nil?
                  url = params[:avatar]
		  agent = Mechanize.new
		  page = agent.get(url)
		  redirect_url = page.uri.to_s
		end
		user.avatar = redirect_url
		user.save
		@user = user
		respond_to do |format|
			format.json { render "getAuthenticationToken" }
		end
	end

        def setLocation
          user = current_user
          user.latitude = params[:latitude].to_s
          user.longitude = params[:longitude].to_s
          user.save
          respond_to do |format|
            format.json
          end
        end
	private

	  def user_params
	    params.require(:user).permit(:signup_process, :preference, :name, :avatar, :gender, :email, :password, :picture)
	  end

end
