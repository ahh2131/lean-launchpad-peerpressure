class UserMailer < ActionMailer::Base
  default from: "mailer@vigme.com"

  def welcome_email(user)
    @user = user
    @url  = 'http://dev.vigme.com:3000'
    mail(to: @user.email, subject: 'Welcome to VigMe!')
  end
end
