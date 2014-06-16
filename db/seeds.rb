# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
#names = ["Crissy Momon", "Audria Mccord", "Clara Graham " ,"Yvone Hug","Melodi Trivett" , "Gregoria Gadson" , "Melida Walborn"  ,"Von Axelson"  ,"Annabelle Russ",  "Violet Collingsworth",  "Broderick Capo"  ,"Delmy Lairsey"  ,"Davina Sperling" , "Polly Mcnaughton" , "Eboni Lokken"  ,"Sona Session"  ,"Marilyn Ormand" , "America Viggiano",  "Miss Luzier"  ,"Lavern Copes"  ,"Ivelisse Calcagno"  ,"Alicia Straw"  ,"Ofelia Pankow"  ,"Setsuko Watt"  ,"Eura Ratti"  ,"Russell Woolverton"  ,"Suzette Pal"  ,"Denyse Shack"  ,"Hayden Broxton"  ,"Wai Guarino"]

30.times do |i|
  User.create(name: "User##{i}")
end