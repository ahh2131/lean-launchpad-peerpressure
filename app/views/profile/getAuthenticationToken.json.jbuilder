
json.user do
    if !@user.nil?
	json.email @user.email
  	json.token @user.authentication_token
    end
end
