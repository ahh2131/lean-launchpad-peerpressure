class PostsController < ApplicationController
skip_before_filter :verify_authenticity_token
 

  def createPost
    @post = Post.new
    @post.description = params[:description]
    @post.price = params[:price]
    @post.user_id = current_user.id
    @post.sold = 0
    @post.photo = params[:url]
    @post.save
    respond_to do |format|
      format.json
    end   
  end

  # get all recent posts, dont count the ones that current user have already seen (check chats) also check location (1mile)
  def getPosts
    
    latitude = current_user.latitude.to_f
    longitude = current_user.longitude.to_f
    recent_users = User.where(updated_at: (Time.now - 7.day)..Time.now).all
    user_array = [] 
   
    recent_users.each do |user|
      if current_user.id != user.id
        dist = haversine( latitude, longitude, user.latitude, user.longitude)
        if dist < 3200
          user_array << user
        end
      end
    end  
     
    @posts = []
    user_array.each do |user|
      posts = Post.where(user_id: user.id, sold: 0).order("created_at desc")
      posts.each do |post|
        # check if a chat exists
        chat = Chat.where(post_id: post.id, user_1: user.id, user_2: current_user.id).first
        if chat.nil?
          @posts << post
        end 
      end
    end
   
        

    respond_to do |format|
      format.json
    end
  end

  def markPostAsSold
  end
 
  def likePost
    chat = Chat.new
    chat.user_1 = params[:user_1]
    chat.user_2 = current_user.id
    chat.post_id = params[:post_id]
    chat.complete = 0
    chat.save

    respond_to do |format|
      format.json
    end
  end

  def dislikePost
    chat = Chat.new
    chat.user_1 = params[:user_1]
    chat.user_2 = current_user.id
    chat.post_id = params[:post_id]
    chat.complete = 1
    chat.save

    respond_to do |format|
      format.json
    end
  end

  def getOwnPosts
    
  end

  
  def haversine(lat1, long1, lat2, long2)
    dtor = Math::PI/180
    r = 6378.14*1000

    rlat1 = lat1 * dtor
    rlong1 = long1 * dtor
    rlat2 = lat2 * dtor
    rlong2 = long2 * dtor

    dlon = rlong1 - rlong2
    dlat = rlat1 - rlat2

    a = power(Math::sin(dlat/2), 2) + Math::cos(rlat1) * Math::cos(rlat2) * power(Math::sin(dlon/2), 2)
    c = 2 * Math::atan2(Math::sqrt(a), Math::sqrt(1-a))
    d = r * c

    return d
  end

  def power(num, pow)
     num ** pow
  end

end
