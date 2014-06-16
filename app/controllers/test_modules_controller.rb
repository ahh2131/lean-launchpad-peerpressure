class TestModulesController < ApplicationController
  before_action :set_test_module, only: [:show, :edit, :update, :destroy]

  # GET /test_modules
  # GET /test_modules.json
  def colorz
  end

  def escape
  end
  
  def index
    @test_modules = TestModule.all
  end

  # GET /test_modules/1
  # GET /test_modules/1.json
  def show
  end

  # GET /test_modules/new
  def new
    @test_module = TestModule.new
  end

  # GET /test_modules/1/edit
  def edit
  end

  # POST /test_modules
  # POST /test_modules.json
  def create
    @test_module = TestModule.new(test_module_params)

    respond_to do |format|
      if @test_module.save
        format.html { redirect_to @test_module, notice: 'Test module was successfully created.' }
        format.json { render :show, status: :created, location: @test_module }
      else
        format.html { render :new }
        format.json { render json: @test_module.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /test_modules/1
  # PATCH/PUT /test_modules/1.json
  def update
    respond_to do |format|
      if @test_module.update(test_module_params)
        format.html { redirect_to @test_module, notice: 'Test module was successfully updated.' }
        format.json { render :show, status: :ok, location: @test_module }
      else
        format.html { render :edit }
        format.json { render json: @test_module.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /test_modules/1
  # DELETE /test_modules/1.json
  def destroy
    @test_module.destroy
    respond_to do |format|
      format.html { redirect_to test_modules_url, notice: 'Test module was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_test_module
      @test_module = TestModule.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def test_module_params
      params[:test_module]
    end
end
