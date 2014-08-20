require 'rails_helper'

module Features
    def sign_up_with(email, password, confirmation)
      visit new_user_session_path
      fill_in 'Email', with: email
      fill_in 'Password', with: password
      fill_in 'Password confirmation', with: confirmation
      click_button 'Sign up'
    end

    def sign_in
      user = FactoryGirl.create(:user)
      visit new_session_path
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      click_button 'Sign in'
      return user
    end

    def sign_in_post_process
      user = FactoryGirl.create(:post_signup_user)
      visit new_session_path
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      click_button 'Sign in'
      p current_url
      return user
    end
end