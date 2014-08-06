require 'open-uri'
require 'uri'
require 'nokogiri'

class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]
layout 'application'


skip_before_filter :verify_authenticity_token


PRODUCTS_PER_USER = 6
MINIMUM_DIMENSION = 50
PER_USER_SIMILAR = 10
USER_PER_PAGE_SOCIAL = 10

  def test
  end

  # GET /products
  # GET /products.json
  def index

    if user_signed_in?
      if current_user.signup_process == 0
        UserMailer.welcome_email(current_user).deliver
        current_user.avatar = "http://s3-us-west-2.amazonaws.com/vigme/users/avatars/000/000/416/original/missing-profile.jpg?1406849266"
        current_user.save
        return redirect_to signup_step_one_path
      elsif current_user.signup_process == 1
        return redirect_to signup_step_two_path
      elsif current_user.signup_process == 2
        return redirect_to signup_step_three_path
      end
    end
    if user_signed_in?
      @user_id = current_user.id
    end
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
  #  url = addFiltersToUrl(url, @categories)
   # page = mechanizeUrl(url)
   # result = JSON.parse page.body
    #@products = result["products"]
    @products = Product.all.limit(50)
    #and send a message
    @not_signed_in = 1
  

    respond_to do |format|
      format.html
      format.js
    end
  end

  def discover
    user_ids = Ranking.where(:time_period => "this_week").order("score desc").page(params[:page]).pluck(:user_id)
    user_profiles = User.where(:id => user_ids).all
    @products_for_each_user = []
    @discover_profiles = []
    user_profiles.each do |profile|
      products = profile.products.limit(6)
      if products.count < 6
        products = Product.where(:retailer_id => profile.retailer_id).limit(6)
      end
      if !(products.count < 6)
       @products_for_each_user << products
       @discover_profiles << profile
      end
    end

    @arrayFollowers = arrayAlreadyFollowed(@discover_profiles)
    @page = params[:page].to_i + 1

    respond_to do |format|
      format.html
      format.js
    end
  end

  def arrayAlreadyFollowed(followers)
    array = []
    followers.each do |follower|
      if user_signed_in?
        activity = current_user.activities.where(:toUser => follower.id)
        .where(:activity_type => "follow").first
      end
      if activity.nil?
        array << 0
      else
        array << 1
      end
    end
    return array
  end
  # bookmarklet goes here, this activity will keep track of purchases and where commission goes
  # only created a purchase if bookmarklet finds keywords and site is https
  def purchased
    if params[:most_recent_product_view].nil?
      most_recent_product_view = session[:most_recent_product_view]
    else
      most_recent_product_view = params[:most_recent_product_view]
    end

    if params[:found] != "-1" && params[:url].to_s.include?("https")
      activity = Activity.new
      activity.activity_type = "purchase"
      activity.purchase_url = params[:url]
      activity.product_id = most_recent_product_view
      activity.fromUser = current_user.id
      to_user = Activity.where(:activity_type => "seen", :fromUser => current_user.id)
      .where(:product => most_recent_product_view).first
      if !to_user.nil?
        activity.toUser = to_user.toUser
      end
      activity.save
    end


    redirect_to product_path(most_recent_product_view)
  end

  def share
    if productAlreadyShared == 0
      activity = Activity.new
      activity.fromUser = current_user.id
      activity.product_id = params[:product]
      activity.activity_type = "save"
      activity.save
    end
    @product_id = params[:product]
    @lists = List.where(:user_id => current_user.id).limit(10)

    respond_to do |format|
      format.html
      format.js { render "share" }
    end
  end

  def purchaseReceipt
    if params[:most_recent_product_view].nil?
      most_recent_product_view = session[:most_recent_product_view]
    else
      most_recent_product_view = params[:most_recent_product_view]
    end
    if purchaseDoesNotExist(most_recent_product_view) == 1
      activity = Activity.new
      activity.activity_type = "purchase"
      activity.purchase_url = params[:url]
      activity.product_id = most_recent_product_view
      activity.fromUser = current_user.id
      to_user = Activity.where(:activity_type => "seen", :fromUser => current_user.id)
      .where(:product_id => most_recent_product_view).first
      if !to_user.nil?
        activity.toUser = to_user.toUser
      end

      activity.confirmed = confirmPurchase(most_recent_product_view, params[:html])
      activity.save
      path = saveToFile(params[:html], activity.id)
      activity.receipt = open(path)
      activity.save
      File.delete(path) if File.exist?(path)
    end
 

    redirect_to product_path(most_recent_product_view)
  end

  def confirmPurchase(product_id, html)
    retailer_id = Product.where(:id => product_id).pluck(:retailer_id)
    if retailer_id.nil?
      return 0
    else
      keywords = Keyword.where(:retailer_id => retailer_id).all.pluck(:word)
      leeway = 1
      matches = 0
      if keywords.count > 0
        keywords.each do |keyword|
          if html.include?(keyword)
            matches = matches + 1
          end
        end
      else
        return -1
      end
      if matches >= (keywords.count - leeway)
        return 1
      elsif matches != 0
        return -1
      else
        return 0
      end
    end
  end

  def saveToFile(html, activity_id)
    doc = Nokogiri.HTML(html)                            # Parse the document

    doc.css('script').remove                             # Remove <script>…</script>
    doc.xpath("//@*[starts-with(name(),'on')]").remove   # Remove on____ attributes
    path = "/log/receipts/" + activity_id.to_s + ".html"
    File.open("/var/www/#{request.host}" + path, "w+") do |f|
      f.write(doc)
    end
    return "/var/www/#{request.host}" + path
  end

  def purchaseDoesNotExist(product_id)
    activity = Activity.where(:activity_type => "purchase", :fromUser => current_user.id)
    .where(:product_id => product_id).first
    if activity.nil?
      return 1
    else
      return 0
    end
  end

  def buy
    session[:most_recent_product_view] = params[:product]
    render nothing: true
  end

  def productAlreadyShared
    activity = Activity.where(:fromUser => current_user.id, :product_id => params[:product], :activity_type => ["save", "add"]).first
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
    p @recent_activity_id_array
    return @recent_activity_id_array
  end

  def getUniqueProductsFromUserArray(perUser, id_array, offset)
    products = []
    id_array.each do |follower_id|
      @product_ids = Activity.order(created_at: :desc).where(:fromUser => follower_id, :activity_type =>["add", "save"]).limit(perUser).offset(offset).pluck(:product_id)
      @product_ids.each do |product_id|
        product = Product.where(:id => product_id).first
        if !product.nil?
          products << product
        end
      end
    end
    # go through products and weed out ones that are the same

    products = products.uniq{|product| product.id}
    return products
  end

  def cycleRecentActivityIdArrayFromIdArray(id_array, limit)

    @activity_array_unprocessed = Activity.order("MAX(created_at) DESC").select(:fromUser, :created_at).where(:fromUser => id_array)
    .where(:activity_type => ["add", "save"]).group(:fromUser).page(params[:page])
    @recent_activity_id_array = []
    @activity_array_unprocessed.each do |activity|
      @recent_activity_id_array << activity.fromUser
    end
    p @recent_activity_id_array

    if @recent_activity_id_array.count == 0
      cycled = 1
      params[:page] = 1
      @recent_activity_id_array, unneeded = cycleRecentActivityIdArrayFromIdArray(id_array, limit)
    else
      cycled = 0
    end
    return @recent_activity_id_array, cycled

  end

  def getSocialFeedProfiles(recent_activity_id_array)
    social_feed_profiles
    @recent_activity_id_array.each do |follower_id|
      user = User.where(:id => follower_id).first
      if !user.nil? && products.count >= PRODUCTS_PER_USER
        social_feed_profiles << user
      end
    end
  end

  # same as more social feed except makes product_offset 0

  def socialFeed

    @follower_id_array = Activity.where(:fromUser => current_user.id)
    .where(:activity_type => "follow").distinct(:toUser).pluck(:toUser)

    @recent_activity_id_array, cycled = cycleRecentActivityIdArrayFromIdArray(@follower_id_array, USER_PER_PAGE_SOCIAL)
    if cycled == 1
      @product_page = params[:product_page].to_i + 1
    else
      @product_page = params[:product_page]
    end
    @products_for_each_user = []
    @social_feed_profiles = []
    @recent_activity_id_array.each do |follower_id|
      @product_ids = Activity.order(created_at: :desc).where(:fromUser => follower_id, :activity_type =>["add", "save"]).page(params[:product_page]).per(PRODUCTS_PER_USER).pluck(:product_id)
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
      else
      end
    end
    if @products_for_each_user[0].nil?
      session[:product_offset] = 0
    end
    @page = params[:page].to_i + 1

  end

 def viglets
 end

  # GET /products/1
  # GET /products/1.json
  def show
    if !params[:modal].nil?
      @modal = 1
    else
      @modal = 0
    end
    product_shared_by_ids = Activity.where(:activity_type => "save", :product_id => params[:id]).limit(10).pluck(:fromUser)
    if user_signed_in?
      product_shared_by_ids.delete(current_user.id.to_s)
      if isProductSeenByUser == 0
        activity = Activity.new 
        activity.fromUser = current_user.id
        activity.activity_type = "seen"
        activity.product_id = params[:id]
        if !params[:from_user].nil? && params[:from_user].to_i != current_user.id.to_i
         activity.toUser = params[:from_user]
        end
        activity.save
      end
    end
    @product_shared_by = User.where(:id => product_shared_by_ids).all
    if @product.retailer_id != -1
      @retailer = Retailers.find(@product.retailer_id)
      @retailer_user = User.where(:retailer_id => @retailer.id).first
      @other_products_from_retailer = findOtherProductsFromRetailer(@retailer)
    end
    users_who_shared_products = Activity.where(:product => params[:id], :activity_type => ["share", "add"]).limit(10).pluck(:fromUser)
    @recent_activity_id_array = getRecentActivityIdArrayFromIdArray(users_who_shared_products, 0, 5)
    session[:similar_products_offset] ||= 0
    @similar_products = getUniqueProductsFromUserArray(PER_USER_SIMILAR, @recent_activity_id_array, session[:similar_products_offset]*PER_USER_SIMILAR)
    if @similar_products[0].nil?
      session[:similar_products_offset] = 0
    else
      session[:similar_products_offset] = session[:similar_products_offset].to_i + 1 
    end
    respond_to do |format|
      format.html { render "show" }
      format.js { render "index" }
    end 
  end

  def showProductModal
    if @product.nil?
      @product = Product.find(params[:id])
    end
    product_shared_by_ids = Activity.where(:activity_type => "save", :product_id => params[:id]).limit(10).pluck(:fromUser)
    if user_signed_in?
      product_shared_by_ids.delete(current_user.id.to_s)
      if isProductSeenByUser == 0
        activity = Activity.new 
        activity.fromUser = current_user.id
        activity.activity_type = "seen"
        activity.product_id = params[:id]
        if !params[:from_user].nil? && params[:from_user].to_i != current_user.id.to_i
         activity.toUser = params[:from_user]
        end
        activity.save
      end
    end
    @product_shared_by = User.where(:id => product_shared_by_ids).all
    if @product.retailer_id != -1
      @retailer = Retailers.find(@product.retailer_id)
      @retailer_user = User.where(:retailer_id => @retailer.id).first
      @other_products_from_retailer = findOtherProductsFromRetailer(@retailer)
    end
    users_who_shared_products = Activity.where(:product => params[:id], :activity_type => ["share", "add"]).limit(10).pluck(:fromUser)
    @recent_activity_id_array = getRecentActivityIdArrayFromIdArray(users_who_shared_products, 0, 5)
    session[:similar_products_offset] ||= 0
    @similar_products = getUniqueProductsFromUserArray(PER_USER_SIMILAR, @recent_activity_id_array, session[:similar_products_offset]*PER_USER_SIMILAR)
    if @similar_products[0].nil?
      session[:similar_products_offset] = 0
    else
      session[:similar_products_offset] = session[:similar_products_offset].to_i + 1 
    end
    respond_to do |format|
      format.html { render "show" }
      format.js { render "show" }
    end 
  end

  def getOffsetMultiplier
    if session[:socialFeedLoaded].to_i == 0
      session[:more] = session[:more].to_i + 1
    else
      session[:more] = 0
    end
    return session[:more].to_i
  end

  def findOtherProductsFromRetailer(retailer)
    other_products = Product.where(:retailer_id => retailer.id)
    .where("image_s3_url IS NOT NULL")
      .order("vigme_inserted desc").limit(6)
  end

  def findOtherProductsFromUser
    original_user = Activity.where(:activity_type => ["save", "add"], :product_id => params[:id]).order("created_at asc").pluck(:fromUser).first
    other_activity_from_user = Activity.where(:activity_type => ["add", "save"], :fromUser => original_user).limit(6).pluck(:product_id)
    @other_products_from_user = Product.find(other_activity_from_user)
    @other_products_from_user.each_with_index  do |product, index|
      if product.id == params[:id].to_i
        @other_products_from_user.slice!(index)
      end
    end
  end

  def isProductSeenByUser
    activity = Activity.where(:activity_type => "seen", :fromUser => current_user.id, :product_id => params[:id]).first
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
      if params[:url].nil?
        session[:product_link] = params[:link][:url]
      else
        session[:product_link] = params[:url]
      end
      itExists = doesProductExist(session[:product_link])
      if itExists != 0
        return render :js => "window.location = '/products/#{itExists.to_s}'"
    #    redirect_to :controller => 'products', :action => 'show', :id => itExists
      else
        url = open(session[:product_link])
        @image_array = []
        numberImagesHeader = numberOfHeaderImages(url)
        headerImage = 0
        # makes an array of image urls after the header ones
        test = Nokogiri::HTML(open(url))
        test.traverse{ |x|
            if x.text? and not x.text =~ /^\s*$/
                puts x.text
                if x.text.include? "$"
                  session[:product_price] = x.text
                end
            end
        }
        session[:product_price] = cleanupPrice(session[:product_price]).to_i
        Nokogiri::HTML(open(url)).xpath("//body//img/@src").each do |src|
          if headerImage >= numberImagesHeader && headerImage < (numberImagesHeader + 25)
            absolute_uri = URI.join(session[:product_link], src ).to_s
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

  def cleanupPrice(price)
    price.delete("\n")
    price.delete("\t")
    price.gsub(/\s+/, "")
    price.delete("$")
  end

  def doesProductExist(url)
    product = Product.where('extractor_url LIKE ?', url).first
    if product.nil?
      return 0
    else
      return product.id
    end
  end


  def createProduct(image_url, name, price, product_url)
    retailer_id = findOrCreateRetailer(product_url)
    product = Product.new
    product.retailer_id = retailer_id
    product.image_s3 = image_url
    product.buy_url = product_url
    product.name = name
    product.extractor_url = product_url
    product.ftp_transfer_processed = 1
    product.ftp_transfer_datetime = Time.now
    product.vigme_inserted = Time.now
    product.price = price
    product.save
    product.image_s3_url = product.image_s3.url
    product.ftp_transfer_deleted_source = 1
    product.ftp_transfer_deleted_source_datetime = Time.now
    product.save
    return product
  end

  def findOrCreateRetailer(product_link)
    new_link = stripProductLink(product_link)
    retailer = Retailers.where('url LIKE ?', new_link).first
    if retailer.nil?
      retailer = Retailers.new
      retailer.url = new_link
      retailer.local_url = new_link
      retailer.name = new_link
      retailer.source = "vigme"
      retailer.active = 0
      retailer.save
      createStoreAccount(retailer.id, retailer.name)
    end
    return retailer.id
  end

  def stripProductLink(product_link)
    new_str = product_link.slice(0..(product_link.index('.com')))
    new_str.slice! "www."
    new_str.slice! "http://"
    new_str.slice! "https://"
    new_str = new_str + "com"
    return new_str
  end

  def createStoreAccount(retailer_id, retailer_name)
    user = User.new
    user.retailer_id = retailer_id
    user.user_type = 2
    user.name = retailer_name
    user.email = "holder@store.com"
    user.password = retailer_name + retailer_id.to_s
    user.save
  end

  def createActivity(product_id)
    activity = Activity.new
    activity.fromUser = current_user.id
    activity.product_id = product_id
    activity.activity_type = "add"
    activity.save
  end

  def displayUrlForm
    respond_to do |format|
      format.html
      format.js { render 'url_form' }
    end
  end

  def categorizeProduct
    image_index = params[:index]
    if image_index.to_i < session[:image_array].count && image_index.to_i >= 0
      session[:product_image_url] = session[:image_array][image_index.to_i]
    else
      redirect_to root_url
    end
    session.delete(:image_array)

    @product = Product.new
    @product.price = session[:product_price]
    @categories = Category.where(:parent => 1).all

    respond_to do |format|
      format.html 
      format.js 
    end
  end
  
  def saveProduct
    # make categories and 
    @product = createProduct(session[:product_image_url], params[:product][:name], session[:product_price], session[:product_link])
    createActivity(@product.id)
    session.delete(:product_link)
    session.delete(:product_price)
    session.delete(:product_image_url)
    createProductCategories(@product.id)
    redirect_to :controller => 'products', :action => 'show', :id => @product.id
  end

  def createProductCategories(product_id)
    categories = Category.where(:parent => 1).all
    categories.each do |category|
      if params[category.name.gsub(/\s+/, "").to_sym].to_i == 1
        product_category = CategoryProduct.new
        product_category.product_id = product_id
        product_category.category_id = category.id
        product_category.save
      end
    end
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
