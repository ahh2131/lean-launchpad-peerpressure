require 'open-uri'
require 'uri'
require 'nokogiri'
class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]
layout 'application'

MINIMUM_DIMENSION = 250

  def test
  end
  # GET /products
  # GET /products.json
  def index
        @user_id = session[:user_id]
        @home_page = 1

        if @user_id
                @followers = Activity.where(:fromUser => @user_id)
                .where(:activity_type => "follow")
                @follower_id_array = []
                @followers.each do |follower|
                        if follower.toUser
                                @follower_id_array << follower.toUser
                        end
                end
                @activities = Activity.where(:fromUser => @follower_id_array)
                .where(:activity_type => "add")
                @product_id_array = []
                @activities.each do |activity|
                        if activity.product
                                @product_id_array << activity.product
                        end
                end
                @products = Product.where(:id => @product_id_array)
        else
                #if user not signed in, get a different set of activity
   # we convert the returned JSON data to native Ruby
   # data structure - a hash
                url ="http://labs.vigme.com/interface/interface_products.php?type=popular&clear=1"
                resp = Net::HTTP.get_response(URI.parse(url))
                data = resp.body
                result = JSON.parse(data)

                @products = result["products"]
                p @products
                #and send a message
                @not_signed_in = 1
        end
  end

  # GET /products/1
  # GET /products/1.json
  def show
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
    session[:product_link] = params[:link][:url]
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

  def createProduct(image_url)
    product = Product.new
    product.image_s3 = image_url
    product.buy_url = session[:product_link]
    product.ftp_transfer_processed = 1
    product.ftp_transfer_datetime = Time.now
    product.image_s3_url = product.image_s3.url
    p product.image_s3.url
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
