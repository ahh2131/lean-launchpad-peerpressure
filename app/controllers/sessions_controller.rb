class SessionsController < ApplicationController
  def create
    user = User.from_omniauth(env["omniauth.auth"])
    request.env['omniauth.auth'].info.image.slice! "?type=square"
    user.image = request.env['omniauth.auth'].info.image
    session[:user_id] = user.id
    if user.avatar_file_size.nil?
      user.avatar = User.process_uri(user.image + "?type=large")
    end
    user.save
    session[:user_image] = user.avatar.url
    redirect_to root_url
  end

  def destroy
    session[:user_id] = nil
    session[:admin_id] = nil
    redirect_to root_url
  end
end
