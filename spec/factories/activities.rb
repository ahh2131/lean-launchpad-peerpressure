require 'faker'
FactoryGirl.define do
  factory :activity do |f|
   f.fromUser 1
   factory :list_activity do
   	activity_type "list"
   end
   factory :save_activity do
      activity_type "save"
   end
   factory :add_to_list_activity do
      activity_type "add_to_list"
   end
   factory :add_activity do
      activity_type "add"
   end
   factory :follow_activity do
      activity_type "follow"
   end
   factory :seen_activity do
      activity_type "seen"
   end
 end
end