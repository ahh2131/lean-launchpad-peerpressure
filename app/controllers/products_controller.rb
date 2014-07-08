require 'open-uri'
require 'uri'
require 'nokogiri'

class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]
layout 'application'

PRODUCTS_PER_USER = 6
MINIMUM_DIMENSION = 250
PER_USER_SIMILAR = 10
USER_PER_PAGE_SOCIAL = 10
  def test
  end
  # GET /products
  # GET /products.json
  def index
        @user_id = session[:user_id]
        @home_page = 1
        @categories = Category.where(:parent => 1)
        url ="http://labs.vigme.com/interface/interface_products.php?type=popular"
        if params[:more].to_i == 1
          more = "&clear=0"
        else
          more = "&clear=1"
        end
        url = url + more
        if params[:all].to_i == 1
          destroyOldFilters(@categories)
        end
        url = addFiltersToUrl(url, @categories)
        page = mechanizeUrl(url)
        result = JSON.parse page.body
        @products = result["products"]
        #and send a message
        @not_signed_in = 1
      

    respond_to do |format|
      format.html
      format.js
    end
  end

  def share
    if productAlreadyShared == 0
      activity = Activity.new
      activity.fromUser = session[:user_id]
      activity.product = params[:product]
      activity.activity_type = "save"
      activity.save
    end
    @product_id = params[:product]
    @lists = List.where(:user_id => session[:user_id]).limit(10)

    respond_to do |format|
      format.html
      format.js { render "share" }
    end
  end

  def productAlreadyShared
    activity = Activity.where(:fromUser => session[:user_id], :product => params[:product], :activity_type => ["save", "add"]).first
    p activity
    if activity.nil?
      return 0
    else
      return 1
    end
  end

  def mechanizeUrl(url)
    # session variable needs to be created otherwise mechanize cant change it
    session[:jar] ||= "holder"
    @agent = Mechanize.new
    if params[:more].to_i == 1
      @agent.cookie_jar.load session[:jar]
    end
    page = @agent.get(url)

    @agent.cookie_jar.save_as session[:jar], :session => true
    return page
  end


  def parseJSON(url)
    resp = Net::HTTP.get_response(URI.parse(url))
    data = resp.body
    result = JSON.parse(data)
    return result
  end

  def addFiltersToUrl(url, categories)
    categories.each do |category|
      p category.name.gsub(/\s+/, "").to_sym
      p params[category.name.gsub(/\s+/, "").to_sym].to_i
      if params[category.name.gsub(/\s+/, "").to_sym].to_i == 1
        destroyOldFilters(categories)
        session[category.name.gsub(/\s+/, "").to_sym] = category.id.to_s
      end
    end
    categories.each do |category|
      if session[category.name.gsub(/\s+/, "").to_sym].to_i != 0
        url = url + "&categories=" + session[category.name.gsub(/\s+/, "").to_sym]
      end
    end
  return url
  end

  def destroyOldFilters(categories)
    categories.each do |category|
      if session[category.name.gsub(/\s+/, "").to_sym].to_i != 0
        session.delete(category.name.gsub(/\s+/, "").to_sym)
      end
    end
  end

  # use this to get a list of user ids that have recent activity, from any list of user id's
  def getRecentActivityIdArrayFromIdArray(id_array, multiplier, limit)

    @activity_array_unprocessed = Activity.order("MAX(created_at) DESC").select(:fromUser, :created_at).where(:fromUser => id_array)
    .where(:activity_type => ["add", "share"]).group(:fromUser).offset(multiplier*limit).limit(limit)
    @recent_activity_id_array = []
    @activity_array_unprocessed.each do |activity|
      @recent_activity_id_array << activity.fromUser
    end
    return @recent_activity_id_array
  end

  def getUniqueProductsFromUserArray(perUser, id_array, offset)
    products = []
    id_array.each do |follower_id|
      @product_ids = Activity.order(created_at: :desc).where(:fromUser => follower_id, :activity_type =>"add").limit(perUser).offset(offset).pluck(:product)
      @product_ids.each do |product_id|
        products << Product.where(:id => product_id).first
      end
    end
    # go through products and weed out ones that are the same
    products = products.uniq{|product| product.id}
    return products
  end

  # document this, super important
  # comment update, SUPER important stuff here
  def socialFeed
    @follower_id_array = Activity.where(:fromUser => session[:user_id])
    .where(:activity_type => "follow").distinct(:toUser).pluck(:toUser)
    # get user ids from activities
    # then use this array of user ids and get products from each
    @recent_activity_id_array = getRecentActivityIdArrayFromIdArray(@follower_id_array, getOffsetMultiplier, USER_PER_PAGE_SOCIAL)
    resetProductOffset
    if @recent_activity_id_array[0].nil?
      session[:more] = 0
      session[:productOffset] = session[:productOffset].to_i + PRODUCTS_PER_USER
      @recent_activity_id_array = getRecentActivityIdArrayFromIdArray(@follower_id_array, 0, USER_PER_PAGE_SOCIAL)
    end
    @products_for_each_user = []
    @social_feed_profiles = []
    @recent_activity_id_array.each do |follower_id|
      @product_ids = Activity.order(created_at: :desc).where(:fromUser => follower_id, :activity_type =>"add").offset(session[:productOffset]).limit(PRODUCTS_PER_USER).pluck(:product)
      products = []
      @product_ids.each do |product_id|
        products << Product.where(:id => product_id).first
      end
      if products.count >= PRODUCTS_PER_USER
        @products_for_each_user << products
      end
      user = User.where(:id => follower_id).first
      if !user.nil? && products.count >= PRODUCTS_PER_USER
        @social_feed_profiles << user
      end

    end

    #### use session[:more] and create a few different lists of products that "fill in"
    #### for users who dont have any more recent products (maybe sponsored, celebrity profiles)


    respond_to do |format|
      format.html
      format.js
    end
 end

 def resetProductOffset
  if params[:more].to_i == 0
    session[:productOffset] = 0
  end
 end

  # GET /products/1
  # GET /products/1.json
  def show
    product_shared_by_ids = Activity.where(:activity_type => "save", :product => params[:id]).limit(10).pluck(:fromUser)
    @product_shared_by = User.find(product_shared_by_ids)
    if !params[:from_user].nil? && params[:from_user].to_i != session[:user_id].to_i
      if isProductSeenByUser == 0
        activity = Activity.new 
        activity.fromUser = session[:user_id]
        activity.activity_type = "seen"
        activity.product = params[:id]
        activity.toUser = params[:from_user]
        activity.save
      end
    end  

    @other_products_from_user = findOtherProductsFromUser

    users_who_shared_products = Activity.where(:product => params[:id], :activity_type => ["share", "add"]).limit(10).pluck(:fromUser)
    @recent_activity_id_array = getRecentActivityIdArrayFromIdArray(users_who_shared_products, getOffsetMultiplier, 5)
    @similar_products = getUniqueProductsFromUserArray(PER_USER_SIMILAR, @recent_activity_id_array, 0)
    p params[:more]
    respond_to do |format|
      format.html { render "show" }
      format.js { render "index" }
    end 
  end

  def getOffsetMultiplier
    if params[:more].to_i == 1
      session[:more] = session[:more].to_i + 1
    else
      session[:more] = 0
    end
    return session[:more].to_i
  end

  def findOtherProductsFromUser
    original_user = Activity.where(:activity_type => ["save", "add"], :product => params[:id]).order("created_at asc").pluck(:fromUser).first
    other_activity_from_user = Activity.where(:activity_type => ["add", "save"], :fromUser => original_user).limit(6).pluck(:product)
    @other_products_from_user = Product.find(other_activity_from_user)
    @other_products_from_user.each_with_index  do |product, index|
      if product.id == params[:id].to_i
        @other_products_from_user.slice!(index)
      end
    end
  end

  def isProductSeenByUser
    activity = Activity.where(:activity_type => "seen", :fromUser => session[:user_id], :toUser => params[:from_user], :product => params[:id]).first
    if activity.nil?
      return 0
    else 
      return 1
    end
  end

  # GET /products/new
  def new
    @product = Product.new
  end

  def make_absolute( href, root )
    URI.parse(root).merge(URI.parse(href)).to_s
  end

  def numberOfHeaderImages(url)
    number = 0
    Nokogiri::HTML(open(url)).xpath("//header//img/@src").each do |src|
      number = number + 1
    end 
    return number
  end

  def imageSizeValid(url)
    p url
    dimensions = FastImage.size(url)
    if dimensions
      if dimensions[0] > MINIMUM_DIMENSION && dimensions[1] > MINIMUM_DIMENSION
        return 1
      else
        return 0
      end
    end
  end

  # form calls this method to get images from url
  def findImages
    # use productExists(params[:link][:url]) == 1 when extractor_url is available

      session[:product_link] = params[:link][:url]
      itExists = doesProductExist(session[:product_link])
      if itExists != 0
        return render :js => "window.location = '/products/#{itExists.to_s}'"
    #    redirect_to :controller => 'products', :action => 'show', :id => itExists
      else
        url = open(params[:link][:url])
        @image_array = []
        numberImagesHeader = numberOfHeaderImages(url)
        headerImage = 0
        # makes an array of image urls after the header ones
        Nokogiri::HTML(open(url)).xpath("//body//img/@src").each do |src|
          if headerImage >= numberImagesHeader
            absolute_uri = URI.join(params[:link][:url], src ).to_s
            if imageSizeValid(absolute_uri) == 1
              @image_array << absolute_uri
            end
          end
          headerImage = headerImage + 1
        end 
        session[:image_array] = @image_array
      end

      respond_to do |format|
        format.html 
        format.js 
      end
      
  end

  def doesProductExist(url)
    product = Product.where(:extractor_url => url).first
    if product.nil?
      return 0
    else
      return product.id
    end
  end


  def createProduct(image_url)
    product = Product.new
    product.image_s3 = image_url
    product.buy_url = session[:product_link]
    product.extractor_url = session[:product_link]
    product.ftp_transfer_processed = 1
    product.ftp_transfer_datetime = Time.now
    product.save
    product.image_s3_url = product.image_s3.url
    product.ftp_transfer_deleted_source = 1
    product.ftp_transfer_deleted_source_datetime = Time.now
    product.save
    return product
  end

  def createActivity(product_id)
    activity = Activity.new
    activity.fromUser = session[:user_id]
    activity.product = product_id
    activity.activity_type = "add"
    activity.save
  end

  def displayUrlForm
    respond_to do |format|
      format.html
      format.js { render 'url_form' }
    end
  end
  
  def saveProduct
    image_index = params[:index]
    if image_index.to_i < session[:image_array].count && image_index.to_i >= 0
      image_url = session[:image_array][image_index.to_i]
      @product = createProduct(image_url)
      createActivity(@product.id)
    else
      redirect_to root_url
    end
    session.delete(:image_array)
    session.delete(:product_link)
    redirect_to :controller => 'products', :action => 'show', :id => @product.id
  end

  # GET /products/1/edit
  #def edit
  #end

  # POST /products
  # POST /products.json
  def create
    @product = Product.new(product_params)

    respond_to do |format|
      if @product.save
        format.html { redirect_to @product, notice: 'Product was successfully created.' }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1
  # PATCH/PUT /products/1.json
  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to @product, notice: 'Product was successfully updated.' }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    @product.destroy
    respond_to do |format|
      format.html { redirect_to products_url, notice: 'Product was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_params
      params.require(:product).permit(:name)
    end
end
