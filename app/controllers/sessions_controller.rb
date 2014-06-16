class SessionsController < ApplicationController
  def create
    user = User.from_omniauth(env["omniauth.auth"])
    request.env['omniauth.auth'].info.image.slice! "?type=square"
    user.image = request.env['omniauth.auth'].info.image
    session[:user_id] = user.id
    session[:user_image] = user.image
    user.save
    redirect_to root_url
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url
  end
end
