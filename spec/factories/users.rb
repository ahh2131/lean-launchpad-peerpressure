require 'faker'
FactoryGirl.define do
  factory :user do |f|
   f.name { Faker::Name.name }
   f.password { Faker::Internet.password(10, 20) }
   f.email { Faker::Internet.email }
   factory :post_signup_user do
   	signup_process 3
   end
   factory :post_user_with_products do
   	signup_process 3
   	transient do
   		products_count 6
   	end

   	after(:create) do |user, evaluator|
   	  create_list(:product, evaluator.products_count, user: user)
   	end
   end
 end
end