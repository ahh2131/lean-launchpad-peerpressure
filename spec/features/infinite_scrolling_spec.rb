require 'rails_helper'
require 'capybara/poltergeist'

feature 'User scrolls to the bottom' do
	include Features
	scenario 'of the discover feed page', js: true, :driver => :poltergeist do
	  FactoryGirl.create_list(:product, 200)
	  user = sign_in_post_process

	  visit discover_path

	  p all('.vigme-product-outline').count
	  page.execute_script('window.scrollTo(0,100000)')
	   p all('.vigme-product-outline').count
	  visit '#product-list'
	  visit '#footer'
	  click('More')
	  page.execute_script('window.scrollTo(0,100000)')

	  p all('.vigme-product-outline').count

	  expect(page).not_to have_errors
	end

end