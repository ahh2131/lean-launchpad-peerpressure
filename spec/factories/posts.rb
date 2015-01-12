# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :post do
    description "MyText"
    price "9.99"
    user_id 1
    sold 1
  end
end
