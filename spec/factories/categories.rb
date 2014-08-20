require 'faker'
FactoryGirl.define do
  factory :category do |f|
   f.parent 1
   f.name { Faker::Commerce.department }
   f.seo_name "test"
   f.synonyms "test"
 end
end