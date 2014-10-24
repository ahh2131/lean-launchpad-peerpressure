require 'rails_helper'
require 'capybara/poltergeist'

feature 'User scrolls to the bottom' do
	include Features
	"""scenario 'of the discover feed page', js: true, :driver => :poltergeist do
	  FactoryGirl.create_list(:product, 200)
	  FactoryGirl.create_list(:category, 10)
	  FactoryGirl.create_list(:user, 15)
	  p current_url

	  sign_in_post_process
	  p current_url

	  expect(page).to have_content('Signed in')


	  #visit discover_path
	 # p page.html
	 # p all('.vigme-product-outline').count
	 # page.execute_script('window.scrollTo(0,100000)')
	#   p all('.vigme-product-outline').count
	  #click_button('More')
	#  page.execute_script('window.scrollTo(0,100000)')

	#  p all('.vigme-product-outline').count

	end"""

end