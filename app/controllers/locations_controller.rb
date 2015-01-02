class LocationsController < ApplicationController
  before_action :set_location, only: [:show, :edit, :update, :destroy]
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
 
    Folder.resetFOLDERPATH
    
    lp = location_params
    if params[:commit] == "unassign"
      lp[:storage_id] = nil
      lp[:inuse] = false
    end

    respond_to do |format|
      if @location.update(lp)
        format.html { redirect_to @location, notice: 'Location was successfully updated.' }
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
    params.require(:location).permit(:name, :uri, :description, :typ, :storage_id, :inuse, :prefix)
  end
end
