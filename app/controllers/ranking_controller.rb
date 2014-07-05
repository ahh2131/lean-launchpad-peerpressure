class RankingController < ApplicationController
	NUMBER_TOP_USERS = 10

	def index
		@topAllTimeUsers = getTopAllTimeUsers(NUMBER_TOP_USERS)
		@topThisWeekUsers = getTopThisWeekUsers(NUMBER_TOP_USERS)
        @categories = Category.where(:parent => 1)

	end

	def getTopAllTimeUsers(number)
		top10id_array= Ranking.where(:category_id => 0, :time_period => "all").order("score desc").limit(number).pluck(:user_id)
		user_array = []
		top10id_array.each do |id|
			user = User.find(id)
			user_array << user
		end
		return user_array
	end

	def getTopThisWeekUsers(number)
		top10id_array= Ranking.where(:category_id => 0, :time_period => "this_week").order("score desc").limit(number).pluck(:user_id)
		user_array = []
		top10id_array.each do |id|
			user = User.find(id)
			user_array << user
		end
		return user_array
	end	

end
