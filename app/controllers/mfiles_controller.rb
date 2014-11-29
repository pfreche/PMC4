class MfilesController < ApplicationController
  before_action :set_mfile, only: [:show, :edit0, :edit, :path, :update, :destroy, :add_attri, :add_attri_name, :remove_attri, :add_agroup, :remove_agroup, :renderMfile]
  # GET /mfiles
  # GET /mfiles.json
  def index
    typ = params[:typ]
    getMfiles(typ)

    render "thumbs"

  end

  def getMfiles(typ)

    if typ == "attribute"
      #     h = new Help
      #     selector = h.attributeSelector

      a = session[:selectedAttris]
      selector = Mfile

      @selectedAttributes = Attri.find(a) if a
      if @selectedAttributes  != nil

        jointext = 'inner join attris_mfiles AS amX on amX.mfile_id = mfiles.id'
        wheretext = 'amX.attri_id'

        #      loop of attribute to build selection
        a.each do |i|
          selector = selector.joins(jointext.gsub("X",i.to_s)).where(wheretext.gsub("X",i.to_s) => i)
        end
        @mfiles = selector.distinct
      else
        @mfiles = Mfile.all
      end

    else if  typ == "folder"
        fid = session[:selectedFolder]
        @mfiles = Mfile.where(folder_id: fid)

      else
        @mfiles = Mfile.find([1,2,3])
      end
    end

  end

  def classify

    typ = params[:typ]
    getMfiles(typ)
    mfs = @mfiles.map(&:id)
    @mfiles = Mfile.includes(:attris, :folder).find(mfs)
    @attris = Attri.joins(:mfiles).where('mfiles.id in (?)', mfs).distinct
    as = @attris.map(&:id)

    #    @agroupssele = Agroup.joins(:attris).where('attris.id in (?)', as).distinct
    #    @agroupssel = @agroupssele.map(&:id)

    @numbers = Agroup.joins(:mfiles).where('mfiles.id in (?)', mfs).group('agroups.id').count(:mfile_id)
    if params[:txt]
      render :classify
    else
      render :classifyPics
    end
  end

  #
  def set_attris

    mf = params[:mfile]
    aorg = params[:AorG] # Attribute or Group

    @ag = (if aorg == "g"
      @name2 = "G-"
      @balken = params[:ag_id]
      @agroup = Agroup.find(params[:ag_id])
    else
      @balken = "nan"
      @name2 = "A-"
      if params[:ag_id] == "-1"
        @attri = Attri.find_by_name(params[:name]||params[:namei])
        @name3 = @attri.agroup.id
        @attri
      else
        @name3 = "nan"
        @attri = Attri.find(params[:ag_id])
      end
    end)


                
                
    mfs = mf.map {|m|   m[0]  }
    @myn = mf.inject({}) do |hash,value|
      hash[value.first.to_i] = value.last.to_i
      hash
    end
    
    @count = 0 
    @mfiles = Mfile.includes(:attris).find(mfs)
    @mfiles.each do |mfile|
      if @myn[mfile.id] == 1
        if @attri
        mfile.attris << @attri unless mfile.attris.exists?(@attri)
        else
        mfile.agroups << @agroup unless mfile.agroups.exists?(@agroup)
        @count +=1
        end

      else if @myn[mfile.id] == 0
        if @myn[mfile.id] == 0
          if @attri
          mfile.attris.delete(@attri)
          else
          mfile.agroups.delete(@agroup)
          end
        end
        end
      end
    end
    @name1 = @ag.name
    @name2 += @ag.id.to_s

  end
  
  def path
    render text: @mfile.path(URLWEB)
  end
  
  def renderMfile
    extension = File.extname(@mfile.filename)
    p extension
    @urlweb = @mfile.path(URLWEB)
    case extension
    when ".jpg", ".jpeg", ".gif", ".png", ".JPG", ".JPEG", ".GIF", ".PNG"
      p "Bild"
#      render text: @mfile.path(URLWEB)
       render "snippet_picture",  layout: false
     when ".mp4"
       p "Film"
       render "snippet_video",  layout: false
     else 
 #            render text: @mfile.path(URLWEB)
    end
  end

  # GET /mfiles/1
  # GET /mfiles/1.json
  def show
  end

  # GET /mfiles/new
  def new
    @mfile = Mfile.new
  end

  # GET /mfiles/1/edit
  def edit
    @attrisFolder = Mfile.joins(folder: {mfiles: :attris}).where(id: @mfile.id).distinct.pluck(:attri_id, "attris.name")
  end

  # GET /mfiles/1/edit
  def edit0
  end

  # POST /mfiles
  # POST /mfiles.json
  def create
    @mfile = Mfile.new(mfile_params)

    respond_to do |format|
      if @mfile.save
        format.html { redirect_to @mfile, notice: 'Mfile was successfully created.' }
        format.json { render action: 'show', status: :created, location: @mfile }
      else
        format.html { render action: 'new' }
        format.json { render json: @mfile.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /mfiles/1
  # PATCH/PUT /mfiles/1.json
  def update
    respond_to do |format|
      if @mfile.update(mfile_params)
        format.html { redirect_to @mfile, notice: 'Mfile was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @mfile.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /mfiles/1
  # DELETE /mfiles/1.json
  def destroy
    @mfile.destroy
    respond_to do |format|
      format.html { redirect_to mfiles_url }
      format.json { head :no_content }
    end
  end

  def add_attri_name

    @attri_name = params[:name]
    attri = Attri.find_by_name(params[:name])
    if attri != nil
      @mfile.attris << attri unless @mfile.attris.exists?(attri)
      @attri_name = nil
    else
      @newAttribute = true
    end

    render "add_attri.js"
  end

  def add_attri

    attri = Attri.find(params[:attri_id])
    if attri != nil
    @mfile.attris << attri unless @mfile.attris.exists?(attri)
    end
    render 'add_attri.js'
  end

  def remove_attri

    attri = Attri.find(params[:attri_id])
    @mfile.attris.delete(attri)
    #   redirect_to edit_location_path(@media_object.location)
    render 'add_attri.js'
  end

  def add_agroup

    agroup = Agroup.find(params[:agroup_id])

    if agroup != nil
    @mfile.agroups << agroup unless @mfile.agroups.exists?(agroup)
    end
    render 'add_attri.js'
  end

  def remove_agroup

    agroup = Agroup.find(params[:agroup_id])
    @mfile.agroups.delete(agroup)
    #   redirect_to edit_location_path(@media_object.location)
    render 'add_attri.js'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_mfile
    @mfile = Mfile.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def mfile_params
    params.require(:mfile).permit(:folder_id, :filename, :modified, :mod_date)
  end
end
