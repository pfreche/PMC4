require 'open-uri'
require "net/http"
require "uri"
#require "nokogiri"

class LocationsController < ApplicationController
  before_action :set_location, only: [:show, :edit, :update, :destroy, :parse, :checkAvail, :parseURL, :gswl, :getTitle, :analyzeFiles, :copyToFiles, :downloadToFiles, :deleteFiles, :scan]
  # GET /locations
  # GET /locations.json
  def index
    dlm = params[:dlm]
    if dlm
      Business::Logic::dlm= dlm.to_i
      a = Business::Logic::dlm
    end
    @locations = Location.all.order(:storage_id)
    @search = params[:search]
    if @search
      render "search"
    end
  end

  # GET /locations/1
  # GET /locations/1.json
  def show
  end

  # GET /locations/new
  def new
    if params[:uri]
      @location = Location.new(uri: params[:uri], name: params[:name])
    else
      if params[:storage_id]
        @location = Location.new(uri: params[:uri], name: params[:name], storage_id: params[:storage_id], typ: 1)
      else
        if params[:id]
           @location = Location.find(params[:id]).dup
        else
           @location = Location.new
        end
      end
    end

  end

  # GET /locations/1/edit
  def edit
    @mfile = @location.mfile
    unless @mfile  # for old locations without mfile
      @mfile = Mfile.new
      @mfile.mtype = MFILE_LOCATION
      @mfile.filename = ""
      @mfile.modified = Time.now
      @mfile.mod_date = Time.now
      @mfile.save
      @location.mfile = @mfile
      @location.save
    end

  end

  def checkAvail

     @success = UriHandler.checkAvail(@location)

     render :text => @success

  end

  def parse

 #   uri = URI.parse(@location.uri)  20150108 wegen Error
    urlbase = @location.uri
    @filter =  params[:filter]

   if @location.typ == URL_WEB
     act= :matchURL
   end
   if @location.typ == URL_STORAGE_FS
     act = :matchDir
   end

   redirect_to :controller => 'uris', :action => 'fetch', :act => act, :path => urlbase
  end

  def parseLinks

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

  def getTitle

    uri = URI.parse(@location.uri)
    begin
      response = Net::HTTP.get_response(uri)
      page = Nokogiri::HTML(open(@location.uri))

      @title = page.css("title")[0].text

    rescue StandardError
      @title = "site not available"

    end

    render plain: @title
  end

  def parseURL
    url = params[:url]
    @links = UriHandler.parse(url,"")

    render "parse"
  end

# ccc checks how many files are physically in the location from all
  def analyzeFiles

     a = UriHandler.checkContent(@location)
     text =  a[1].to_s
     text = text + " from " + a[0].to_s
     render :text => text

  end

# ccc Scans files on the storage
  def scan

    @commit = params[:commit]
    if @commit
      level = @commit[23,1].to_i
       @files = @location.scanAndAdd(level)
    else
      @files = @location.scan
    end
  end


# copy files

  def copyToFiles

     toLocation   = @location
     fromLocation = toLocation.storage.location(URL_STORAGE_FS)

     UriHandler.mkDirectories(toLocation)

     text = UriHandler.copyFiles(fromLocation, toLocation)

     render :text => text

  end

# download files
  def downloadToFiles

     toLocation   = @location
     fromLocation = toLocation.storage.location(URL_STORAGE_WEB)

     UriHandler.mkDirectories(toLocation)

     text = UriHandler.copyFiles(fromLocation, toLocation)

#    text = "Number of Files " + a[0].to_s
#     text = text + " / Files copied " + a[1].to_s
     render :text => text
  end

# delete files

  def deleteFiles
     a = UriHandler.deleteFiles(@location)

     text = a[1].to_s
     text = text + " from " + a[1].to_s + " deleted"
     render :text => text

  end

# Generate Storage with Location

  def gswl

    storageNew = Storage.new
    storageNew.name = @location.name.first(20) # weil name im Moment noch auf 20 Zeichen limitiert ist
    storageNew.save

    locationNew = Location.new
    locationNew.name = @location.name


    uri = URI.parse(@location.uri)

    locationNew.uri = uri.scheme + "://"+uri.host

    locationNew.typ = URL_STORAGE_WEB
    locationNew.inuse = true
    locationNew.storage = storageNew
    locationNew.save

    @mfile = locationNew.mfile
    unless @mfile  # for old locations without mfile
      @mfile = Mfile.new
      @mfile.mtype = MFILE_LOCATION
      @mfile.filename = ""
      @mfile.modified = Time.now
      @mfile.mod_date = Time.now
      @mfile.save
      locationNew.mfile = @mfile
      locationNew.save
    end

    render "edit"
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
      mfile.filename = ""
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

    gotoLocation = true if  params[:commit] == "Save and go to Storage"

    respond_to do |format|
      if @location.update(lp)
        format.html {
           unless gotoLocation
              redirect_to edit_location_path(@location.id), notice: 'Location was successfully updated.'
           else
              redirect_to edit_storage_path(@location.storage.id), notice: 'Location was successfully updated.'
           end
           }
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
    @location.mfile.destroy if @location.mfile
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
    params.require(:location).permit(:name, :uri, :description, :typ, :storage_id, :inuse, :origin, :prefix, :requestTitle, :dlm)
  end
end
