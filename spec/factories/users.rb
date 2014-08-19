require 'faker'
FactoryGirl.define do
  factory :user do |f|
   f.name { Faker::Name.name }
   f.password { Faker::Internet.password(10, 20) }
   f.email { Faker::Internet.email }

   factory :post_signup_user do
   	signup_process 3
   end
 end
end