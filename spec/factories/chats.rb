# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :chat do
    user_1 1
    user_2 1
    post_id "MyString"
    complete 1
  end
end
