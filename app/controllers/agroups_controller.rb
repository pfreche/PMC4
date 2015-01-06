class AgroupsController < ApplicationController
  before_action :set_agroup, only: [:show, :edit, :update, :destroy]

  # GET /agroups
  # GET /agroups.json
  def index
    @agroups = Agroup.all
    @mfilesN = Mfile.count
    
    @numbers = Agroup.joins(:mfiles).group('agroups.id').count(:mfile_id)
    
  end

  def indexedit
    @agroups = Agroup.all
  end
  
  # GET /agroups/1
  # GET /agroups/1.json
  def show
  end

  # GET /agroups/new
  def new
    @agroup = Agroup.new
  end

  # GET /agroups/1/edit
  def edit
  end

  # POST /agroups
  # POST /agroups.json
  def create
    @agroup = Agroup.new(agroup_params)

    respond_to do |format|
      if @agroup.save
        format.html { redirect_to @agroup, notice: 'Agroup was successfully created.' }
        format.json { render action: 'show', status: :created, location: @agroup }
      else
        format.html { render action: 'new' }
        format.json { render json: @agroup.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /agroups/1
  # PATCH/PUT /agroups/1.json
  def update
    respond_to do |format|
      if @agroup.update(agroup_params)
        format.html { redirect_to @agroup, notice: 'Agroup was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @agroup.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /agroups/1
  # DELETE /agroups/1.json
  def destroy
    @agroup.destroy
    respond_to do |format|
      format.html { redirect_to agroups_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_agroup
      @agroup = Agroup.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def agroup_params
      params.require(:agroup).permit(:name)
    end
end
