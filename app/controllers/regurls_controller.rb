class RegurlsController < ApplicationController
  before_action :set_regurl, only: [:show, :edit, :update, :destroy, :check]
  # GET /regurls
  # GET /regurls.json
  def index
    @regurls = Regurl.all
  end

  # GET /regurls/1
  # GET /regurls/1.json
  def show
  end

  # GET /regurls/new
  def new
    @regurl = Regurl.new
  end

  # GET /regurls/1/edit
  def edit
  end

  # POST /regurls
  # POST /regurls.json
  def create
    @regurl = Regurl.new(regurl_params)

    respond_to do |format|
      if @regurl.save
        format.html { redirect_to @regurl, notice: 'Regurl was successfully created.' }
        format.json { render :show, status: :created, location: @regurl }
      else
        format.html { render :new }
        format.json { render json: @regurl.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /regurls/1
  # PATCH/PUT /regurls/1.json
  def update

    @commit = params[:commit]

    result = @regurl.update(regurl_params)

    if @commit == "Match Pattern"

       
#     regex = %r{#{params[:regurl][:pattern]}}      
#      result = regex.match(params[:regurl][:examURL])
      
 #     result = match(@regurl.pattern,@regurl.examURL)
      result = @regurl.match(@regurl.examURL)
      @matche =  result[1]

      render :edit
    else

      respond_to do |format|
        if result
          format.html { redirect_to @regurl, notice: 'Regurl was successfully updated.' }
          format.json { render :show, status: :ok, location: @regurl }
        else
          format.html { render :edit }
          format.json { render json: @regurl.errors, status: :unprocessable_entity }
        end
      end
    end

  end

  def check

    if @regurl.update(regurl_params)
      else
      format.html { render :edit }
      format.json { render json: @regurl.errors, status: :unprocessable_entity }
    end
    adfa

  end

  # DELETE /regurls/1
  # DELETE /regurls/1.json
  def destroy
    @regurl.destroy
    respond_to do |format|
      format.html { redirect_to regurls_url, notice: 'Regurl was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def match
    
    @url = params[:url]

    @matches = UriHandler.getMatches(@url)
    
  end

  private

  #
  def matc(pattern, url)

    regex = %r{#{pattern}}

    result = regex.match(url)

  end

  # Use callbacks to share common setup or constraints between actions.
  def set_regurl
    @regurl = Regurl.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def regurl_params
    params.require(:regurl).permit(:pattern, :extract, :examURL, :fin, :url)
  end
end
