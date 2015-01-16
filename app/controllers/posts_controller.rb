class PostsController < ApplicationController
skip_before_filter :verify_authenticity_token
 
  def getPostDetail
    @post = Post.find(params[:post_id])
    @user = User.find(@post.user_id)
  end  
  def createPost
    @post = Post.new
    @post.name = params[:name]
    @post.description = params[:description]
    @post.price = params[:price]
    @post.user_id = current_user.id
    @post.sold = 0
    @post.photo = params[:url]
    @post.save
    filters = getFilters() 
    p filters
    filters.each do |filter|
      c = CategoryProduct.new
      c.product_id = 0
      c.post_id = @post.id
      c.category_id = filter
      c.save
    end
    respond_to do |format|
      format.json
    end   
  end
  
  def getYardPosts
    latitude = current_user.latitude.to_f
    longitude = current_user.longitude.to_f
    recent_users = User.where(updated_at: (Time.now - 7.day)..Time.now).all
    user_array = []

    recent_users.each do |user|
     # uncommented for testing with myself lol
#      if current_user.id != user.id
        dist = haversine( latitude, longitude, user.latitude, user.longitude)
        if dist < 3200
          user_array << user
        end
 #     end
    end

    @posts = []
    user_array.each do |user|
      filters = getFilters()
      if filters.count != 0
      posts = Post.where(user_id: user.id, sold: 0).order("created_at desc").filter_by_category(getFilters())
      else
        posts = Post.where(user_id: user.id, sold: 0).where("price < 20").order("created_at desc")
      end
      posts.each do |post|
        # check if a chat exists
        chat = Chat.where(post_id: post.id, user_1: user.id, user_2: current_user.id).first
        if chat.nil?
          @posts << post
        end
      end
    end

    if !params[:search].nil?
      new_posts = []
      @posts.each do |post|
        if post.description.downcase().include? params[:search]
          new_posts << post
        end
      end
      @posts = new_posts
    end
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
     # uncommented for testing with myself lol
#      if current_user.id != user.id
        dist = haversine( latitude, longitude, user.latitude, user.longitude)
        if params[:distance].nil?
          if dist < 3200
            user_array << user
          end
        else
          if dist < (1600*params[:distance].to_f)
            user_array << user
          end
        end
 #     end
    end  
     
    @posts = []
    user_array.each do |user|
      filters = getFilters()
      if filters.count != 0
      posts = Post.where(user_id: user.id, sold: 0).order("created_at desc").filter_by_category(getFilters())
        if !params[:price].nil? && params[:price].to_i < 100
          posts = posts.where("price <= ?", params[:price])
        end
      else
        posts = Post.where(user_id: user.id, sold: 0).order("created_at desc")
        if !params[:price].nil? && params[:price].to_i < 100
          posts = posts.where("price <= ?", params[:price])
        end
      end
    """ posts.each do |post|
        # check if a chat exists
        chat = Chat.where(post_id: post.id, user_1: user.id, user_2: current_user.id).first
        if chat.nil?
          @posts << post
        end 
      end"""
      @posts = posts
    end
   
    if !params[:search].nil?    
      new_posts = []
      @posts.each do |post|
        if post.description.downcase().include? params[:search]
          new_posts << post
        end
      end
      @posts = new_posts
    end
    respond_to do |format|
      format.json
    end
  end

  def getFilters()
    toReturn = []
    if params[:furniture] == "1"
      toReturn << 1
    end
    if params[:appliances] == "1"
      toReturn << 2
    end 
    if params[:books] == "1"
      toReturn << 3
    end
    if params[:electronics] == "1"
      toReturn << 4
    end
    if params[:rentals] == "1"
      toReturn << 5
    end
    if params[:tickets] == "1"
      toReturn << 6
    end
    if params[:clothing] == "1"
      toReturn << 7
    end
    if params[:other] == "1"
      toReturn << 8
    end
    return toReturn
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
