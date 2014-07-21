class User < ActiveRecord::Base

  has_attached_file :avatar

  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/



  def self.from_omniauth(auth)
    where(auth.slice(:provider, :uid)).first_or_initialize.tap do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.name = auth.info.name
      user.oauth_token = auth.credentials.token
      user.oauth_expires_at = Time.at(auth.credentials.expires_at)
      user.save!
    end
  end

  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
      user = User.create( image:process_uri(auth.info.image))
  end

  private

  def self.process_uri(uri)
     avatar_url = URI.parse(uri)
     avatar_url.scheme = 'https'
     avatar_url.to_s
  end

end
