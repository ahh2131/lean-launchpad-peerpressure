require 'faker'
FactoryGirl.define do
  factory :product do |f|
   f.name { Faker::Commerce.product_name }
   f.price { Faker::Commerce.price }
   f.search_tags { Faker::Commerce.product_name }
   f.palette_processed '2014-06-19 02:19:29'
   f.ftp_transfer_datetime '2014-06-17 19:57:25'
   f.ftp_transfer_deleted_source_datetime '2014-06-17 19:57:25'
   f.local_extract_date '2014-06-17 19:57:25'
   f.vigme_inserted '2014-06-17 19:57:25'
   f.product_updated '2014-06-17 19:57:25'
 end
end