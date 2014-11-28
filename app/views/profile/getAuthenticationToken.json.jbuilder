
json.user do
	json.email @user.email
	json.token @user.authentication_token
end
