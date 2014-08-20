require 'rails_helper'
require 'capybara/poltergeist'

feature 'User scrolls to the bottom' do
	include Features
	scenario 'of the discover feed page', js: true, :driver => :poltergeist do
	  FactoryGirl.create_list(:product, 200)
	  FactoryGirl.create_list(:category, 10)
	  FactoryGirl.create_list(:user, 15)

	  sign_in_post_process


	  p all('.vigme-product-outline').count
	  page.execute_script('window.scrollTo(0,100000)')
	   p all('.vigme-product-outline').count
	  click_button('More')
	  page.execute_script('window.scrollTo(0,100000)')

	  p all('.vigme-product-outline').count

	  expect(page).not_to have_errors
	end

end