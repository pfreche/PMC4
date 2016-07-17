class MtypesController < ApplicationController

before_action :set_mtype, only: [:show, :edit, :update, :destroy]

  # GET /media_types
  # GET /media_types.json
  def index
    @mtypes = Mtype.all
  end

  # GET /media_types/1
  # GET /media_types/1.json
  def show
  end

  # GET /media_types/new
  def new
    @mtype = Mtype.new
  end

  # GET /media_types/1/edit
  def edit
  end

  # POST /media_types
  # POST /media_types.json
  def create
    @mtype = Mtype.new(mtype_params)

    respond_to do |format|
      if @mtype.save
        format.html { redirect_to @mtype, notice: 'Media type was successfully created.' }
        format.json { render :show, status: :created, location: @mtype }
      else
        format.html { render :new }
        format.json { render json: @mtype.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /media_types/1
  # PATCH/PUT /media_types/1.json
  def update
    respond_to do |format|
      if @mtype.update(mtype_params)
        format.html { redirect_to @mtype, notice: 'Media type was successfully updated.' }
        format.json { render :show, status: :ok, location: @mtype }
      else
        format.html { render :edit }
        format.json { render json: @mtype.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /media_types/1
  # DELETE /media_types/1.json
  def destroy
    @mtype.destroy
    respond_to do |format|
      format.html { redirect_to mtypes_url, notice: 'Media type was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_mtype
      @mtype = Mtype.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def mtype_params
      params.require(:mtype).permit(:name)
    end
end
