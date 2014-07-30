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
  	list.user_id = current_user.id
  	list.save
  	activity = Activity.new
  	activity.fromUser = session[:user_id]
  	activity.activity_type = "list"
  	activity.list_id = list.id
  	activity.save
  	respond_to do |format|
  		format.html
  		format.js { render "create" }
  	end
  end

  def addProductToList
    if params[:list_id].to_i == 0
    else
      if productNotInList(params[:list_id], params[:product_id], current_user.id) == 1
        activity = Activity.new
        activity.list_id = params[:list_id]
        activity.product = params[:product_id]
        activity.fromUser = current_user.id
        activity.activity_type = "add_to_list"
        activity.save
      end
    end
    redirect_to product_path(params[:product_id])
  end

  def productNotInList(list_id, product_id, user_id)
    activity = Activity.where(:list_id => list_id, :product => product_id, :fromUser => user_id).first
    if activity.nil?
      return 1
    else
      return 0
    end
  end

end
