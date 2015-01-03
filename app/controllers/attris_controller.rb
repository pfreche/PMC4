class AttrisController < ApplicationController
  before_action :set_attri, only: [:show, :edit, :update, :destroy]

  # GET /attris/autocomplete
  def autocomplete
    @attris = Attri.order(:name).where("name like ?", "%#{params[:term]}%")
    render json: @attris.map() {|a| a.name}
  end

  # find mfiels for a given attribute
  def find

    attri = Attri.find(params[:id])
    if attri != nil
      a =Mfile.joins(:attris).where("attris.id = ?", attri.id)
      @mfiles = a
      render 'mfiles/index'
    else
      @newAttribute = true
      render 'search'
    end

  end

  #
  def index

    id_add = params[:id_add]
    id_remove = params[:id_remove]
    id_select = params[:id_select]
    id_reset  = params[:reset]

    a = session[:selectedAttris]

    if id_reset
      session[:selectedAttris] = nil
      session[:nsa] = nil
      a = nil
    end

    if id_remove
      @attri = Attri.find(params[:id_remove])
      ar = []
      a.each do |i|
        ar << i unless i == @attri.id
      end
    a = ar
    end

    if id_add
      @attri = Attri.find(params[:id_add])
      if a
      a << @attri.id
      else
      a = []
      a << @attri.id
      end
    a.uniq!
    end

    if id_select
      @attri = Attri.find(params[:id_select])
    a = []
    a << @attri.id
    end
    session[:selectedAttris] = a

    selector = Attri.joins(:mfiles)

    @selectedAttributes = Attri.find(a) if a
    if @selectedAttributes  != nil

      jointext = 'inner join attris_mfiles AS amX on amX.mfile_id = mfiles.id'
      wheretext = 'amX.attri_id'

      #      loop of attribute to build selection
      a.each do |i|
        selector = selector.joins(jointext.gsub("X",i.to_s)).where(wheretext.gsub("X",i.to_s) => i)
      end
      @attris = selector.distinct.to_a
    else
      @attris = Attri.all.to_a    
    end

    @numbers = selector.group('attris.id').count('attris_mfiles.mfile_id')
    @numbersall = Attri.joins(:mfiles)\
          .group('attris.id').count('attris_mfiles.mfile_id')

 
    @attris.sort! {|a,b| @numbers[b.id].to_i <=> @numbers[a.id].to_i}

    # else
    # @newAttribute = true
    # render 'search'

    render 'index'
  end

  # GET /attris
  # GET /attris.json

  def indexu

    session[:selectedAttris] = nil

    session[:nsa] = nil

    @attris = Attri.all

    @numbers = Attri.joins(:mfiles).distinct.group('attris.id').count('attris_mfiles.mfile_id')
    @numbersall = @numbers

    @attris.sort! {|a,b| @numbers[b.id].to_i <=> @numbers[a.id].to_i}

  end

  # GET /attris/overview

  def overview
    @attris = Attri.joins(:mfiles).group('attris.id').count(:mfile_id)

    render text: @attris.to_s
  end

  # GET /attris/1
  # GET /attris/1.json
  def show
  end

  # GET /attris/new
  def new
    @attri = Attri.new
  end

  # GET /attris/1/edit
  def edit
  end

  # POST /attris
  # POST /attris.json
  def create
    @attri = Attri.new(attri_params)

    respond_to do |format|
      if @attri.save
        format.html { redirect_to @attri, notice: 'Attri was successfully created.' }
        format.json { render action: 'show', status: :created, location: @attri }
      else
        format.html { render action: 'new' }
        format.json { render json: @attri.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /attris/1
  # PATCH/PUT /attris/1.json
  def update
    respond_to do |format|
      if @attri.update(attri_params)
        format.html { redirect_to @attri, notice: 'Attri was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @attri.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /attris/1
  # DELETE /attris/1.json
  def destroy
    @attri.destroy
    respond_to do |format|
      format.html { redirect_to attris_url }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_attri
    @attri = Attri.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def attri_params
    params.require(:attri).permit(:name, :agroup_id, :id_sort, :parent_id, :keycode)
  end
end
