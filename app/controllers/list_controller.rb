class ListController < ApplicationController

  def displayListForm
  	@list = List.new
    respond_to do |format|
      format.html
      format.js { render 'list_form' }
    end
  end

  def create
  	list = List.new
  	list.title = params[:list][:title]
  	list.user_id = session[:user_id]
  	list.save
  	activity = Activity.new
  	activity.fromUser = session[:user_id]
  	activity.activity_type = "list"
  	activity.product = list.id
  	activity.save
  	respond_to do |format|
  		format.html
  		format.js { render "create" }
  	end
  end

end
