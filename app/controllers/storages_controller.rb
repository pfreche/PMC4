class StoragesController < ApplicationController
  before_action :set_storage, only: [:show, :edit, :update, :destroy]
  # GET /storages
  # GET /storages.json
  def index
    @storages = Storage.all
  end

  # GET /storages/1
  # GET /storages/1.json
  def show
  end

  # GET /storages/new
  def new
    @storage = Storage.new
  end

  # GET /storages/1/edit
  def edit
  end

  # POST /storages
  # POST /storages.json
  def create
    @storage = Storage.new(storage_params)

    respond_to do |format|
      if @storage.save
        format.html { redirect_to @storage, notice: 'Storage was successfully created.' }
        format.json { render action: 'show', status: :created, location: @storage }
      else
        format.html { render action: 'new' }
        format.json { render json: @storage.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /storages/1
  # PATCH/PUT /storages/1.json
  def update
    @storage.webLocation
    @storage.location(1)

    typs = params[:typ]
    @locations = Location.where(storage_id: @storage.id)
    
    for location in @locations
      location.inuse = false
      if typs
        for typ in typs do
          if typ[1].to_i == location.id
          location.inuse = true
          end
        end
      end
      location.save
    end
    if typs
      for typ in typs do
          Folder.setFolderPath(typ[1].to_i)
      end
    end
    

    
    # locs = params[:location]
    # @locations = Location.where(storage_id: @storage.id)
    # for location in @locations
    # location.inuse = false
    # if locs
    # for loc in locs do
    # if loc[0].to_i == location.id
    # location.inuse = true
    # end
    # end
    # end
    # location.save
    # end

    # for loc in locs
    # location = Location.find(loc[0])
    # location.inuse = true
    # location.save
    # end

    respond_to do |format|
      if @storage.update(storage_params)
        format.html { redirect_to @storage, notice: 'Storage was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @storage.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /storages/1
  # DELETE /storages/1.json
  def destroy
    @storage.destroy
    respond_to do |format|
      format.html { redirect_to storages_url }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_storage
    @storage = Storage.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def storage_params
    params[:storage].permit(:name, :path)
  end
end
