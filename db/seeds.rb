# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
#names = ["Crissy Momon", "Audria Mccord", "Clara Graham " ,"Yvone Hug","Melodi Trivett" , "Gregoria Gadson" , "Melida Walborn"  ,"Von Axelson"  ,"Annabelle Russ",  "Violet Collingsworth",  "Broderick Capo"  ,"Delmy Lairsey"  ,"Davina Sperling" , "Polly Mcnaughton" , "Eboni Lokken"  ,"Sona Session"  ,"Marilyn Ormand" , "America Viggiano",  "Miss Luzier"  ,"Lavern Copes"  ,"Ivelisse Calcagno"  ,"Alicia Straw"  ,"Ofelia Pankow"  ,"Setsuko Watt"  ,"Eura Ratti"  ,"Russell Woolverton"  ,"Suzette Pal"  ,"Denyse Shack"  ,"Hayden Broxton"  ,"Wai Guarino"]

# user 15 adds a bunch of products
30.times do |i|
  Activity.create(fromUser: 15, activity_type: "add", product: "#{i+1}")
end

# user 18 adds a bunch of products 
30.times do |i|
  Activity.create(fromUser: 18, activity_type: "add", product: "#{i+300}")
end


# user 16 adds a bunch of products 
30.times do |i|
  Activity.create(fromUser: 16, activity_type: "add", product: "#{i+31}")
end

#user 23 add a bunch oof products
30.times do |i|
  Activity.create(fromUser: 23, activity_type: "add", product: "#{i+100}")
end

# user 18 follows 15, 16, and 17
Activity.create(fromUser: 18, toUser: 15, activity_type: "follow")
Activity.create(fromUser: 18, toUser: 16, activity_type: "follow")
Activity.create(fromUser: 18, toUser: 17, activity_type: "follow")

# user 19 follows 23, 16, and 18
Activity.create(fromUser: 19, toUser: 23, activity_type: "follow")
Activity.create(fromUser: 19, toUser: 16, activity_type: "follow")
Activity.create(fromUser: 19, toUser: 18, activity_type: "follow")
