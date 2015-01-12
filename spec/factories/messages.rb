# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :message do
    chat_id 1
    from_user_id 1
    to_user_id 1
    message "MyText"
  end
end
