OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, '635183569905094', '845370759c59620c15b4b98c70000f78', :scope => 'user_photos,user_friends,email,read_stream', :info_fields => 'email,name,gender'
end
