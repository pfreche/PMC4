require 'open-uri'
require "net/http"
require "uri"
#require "nokogiri"

class LocationsController < ApplicationController
  before_action :set_location, only: [:show, :edit, :update, :destroy, :parse, :checkAvail]
  # GET /locations
  # GET /locations.json
  def index
    @locations = Location.all.order(:storage_id)
  end

  # GET /locations/1
  # GET /locations/1.json
  def show
  end

  # GET /locations/new
  def new
    @location = Location.new
    @location = Location.new(uri: params[:uri], name: params[:name])
  end

  # GET /locations/1/edit
  def edit
    @mfile = @location.mfile 
    unless @mfile  # for old locations without mfile
      @mfile = Mfile.new
      @mfile.mtype = MFILE_LOCATION
      @mfile.filename = "TBD"
      @mfile.modified = Time.now
      @mfile.mod_date = Time.now
      @mfile.save
      @location.mfile = @mfile
      @location.save
    end
       # check response
       
 
       
#   open (@location.uri) do |f|
      
 #   end
  end
  
  def checkAvail
    
     uri = URI.parse(@location.uri)
     begin
       response = Net::HTTP.get_response(uri)

       @title = "site is there"
     rescue StandardError
       @title = "site not available"
    end
    render :text => @title
    
  end

  def parse

    uri = URI.parse(@location.uri)
    urlbase = @location.uri
    begin
       response = Net::HTTP.get_response(uri)
       page = Nokogiri::HTML(open(@location.uri))
       
       @title = page.css("title")[0].text
      links = page.css("a")

      links.each do |l|
         name = l.attr("href").to_s
         @title+=  "Href: " +name + " "
         url = URI.join(urlbase, name)
         @title+=  url.to_s + " <p>"
#         puts "Kompletter URI: "+ url.to_s
#         puts "img: " + l.css("img").to_s
#         imgs = l.css("img")

       end


   rescue StandardError
     #@title+= "site not available"
#      doc = Nokogiri::HTML(open(@location.uri))
#      @title = doc.css('title')
    end
    render :text => @title
  end

  def parseLInks

    uri = URI.parse(@location.uri)
    begin
      response = Net::HTTP.get_response(uri)
      page = Nokogiri::HTML(open(@location.uri))

      @title = page.css("title")[0].text

    rescue StandardError
      @title = "site not available"
#      doc = Nokogiri::HTML(open(@location.uri))
#      @title = doc.css('title')
    end
  end



  # POST /locations
  # POST /locations.json
  def create
    
    Folder.resetFOLDERPATH
    @location = Location.new(location_params)

    # @location.typ = 2
    #
    # if @location.uri[0..3] == "http"
    # @location.typ = 1
    # end
    if @location.typ == URL_WEB or true # create mfile if URL_WEB, nicht für alle ?
      #create mfile
      mfile = Mfile.new
      mfile.mtype = MFILE_LOCATION
      mfile.filename = "TBD"
      mfile.modified = Time.now
      mfile.mod_date = Time.now
      mfile.save
      @location.mfile = mfile
    end

    respond_to do |format|
      if @location.save
        format.html { redirect_to @location, notice: 'Location was successfully created.' }
        format.json { render action: 'show', status: :created, location: @location }
      else
        format.html { render action: 'new' }
        format.json { render json: @location.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /locations/1
  # PATCH/PUT /locations/1.json
  def update
 
 
    if @location.typ != URL_WEB 
      Folder.resetFOLDERPATH
    end 
    
    lp = location_params
    if params[:commit] == "unassign"
      lp[:storage_id] = nil
      lp[:inuse] = false
    end

    respond_to do |format|
      if @location.update(lp)
        format.html { redirect_to edit_location_path(@location.id), notice: 'Location was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @location.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /locations/1
  # DELETE /locations/1.json
  def destroy
    @location.mfile.destroy
#    @location.destroy # obsolete as mfile has  dependent destroy on location
    respond_to do |format|
      format.html { redirect_to locations_url }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_location
    @location = Location.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def location_params
    params.require(:location).permit(:name, :uri, :description, :typ, :storage_id, :inuse, :prefix, :requestTitle)
  end
end
