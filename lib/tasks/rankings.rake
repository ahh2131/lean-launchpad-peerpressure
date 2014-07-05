namespace :rankings do
  desc "updates rankings for the vig leagues"
  task update: :environment do
  	User.find_each do |user|
  		updateAllTimeRankings(user.id)
  		updateThisWeekRankings(user.id)
  	end
  end

  def updateAllTimeRankings(user_id)
  	ranking = Ranking.where(:user_id => user_id).first_or_create
	ranking.category_id = 0
	ranking.time_period = "all"
	ranking.score = Activity.where(:toUser => user_id, :activity_type => ["seen", "save"]).count
	ranking.save
  end

  def updateThisWeekRankings(user_id)
  	ranking = Ranking.where(:user_id => user_id, :time_period => "this_week").first_or_create
  	ranking.category_id = 0
  	ranking.score = Activity.where(:toUser => user_id, :activity_type => ["seen", "save"])
  	.where("created_at >= :start AND created_at < :end",
  	 :start => 1.week.ago.to_date,
  	 :end => Date.today).count
  	ranking.save
  end

end
