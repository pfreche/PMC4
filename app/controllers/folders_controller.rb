class FoldersController < ApplicationController
  before_action :set_folder, only: [:show, :edit, :update, :destroy, :copyFiles, :generateTNs, :changeStorage]

  # GET /folders
  # GET /folders.json
  def index
    @folders = Folder.all.order(:id)
        @numbers = Folder.joins(:mfiles).group('folders.id').count('mfiles.id')
        @numbersa = Folder.joins(mfiles: :agroups).group('folders.id').group('agroups.id').count('mfiles.id')
  #      @numbersa = Folder.joins(mfiles: :agroups).group('folders.id').count('mfiles.id')
    @agroups = Agroup.all

  end

  def indexedit
    @folders = Folder.all
  end

  # GET /folders/1
  # GET /folders/1.json
  def show
    session[:selectedFolder] = @folder.id
    typ = params[:typ]
    if typ
      if typ == "next"
        @folder = Folder.find(@folder.id).next
      end
      if typ == "prev"
        @folder = Folder.find(@folder.id).previous
      end
      session[:selectedFolder] = @folder.id
    end
    @mfiles = @folder.mfiles
    @bookmark = Bookmark.find_by_folder_id(@folder.id)
  end

  # GET /folders/new
  def new
    @folder = Folder.new
  end

  # GET /folders/1/edit
  def edit
  end

  # POST /folders
  # POST /folders.json
  def create
    @folder = Folder.new(folder_params)

    respond_to do |format|
      if @folder.save
        format.html { redirect_to @folder, notice: 'Folder was successfully created.' }
        format.json { render action: 'show', status: :created, location: @folder }
      else
        format.html { render action: 'new' }
        format.json { render json: @folder.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /folders/1
  # PATCH/PUT /folders/1.json
  def update
    respond_to do |format|
      if @folder.update(folder_params)
        format.html { redirect_to @folder, notice: 'Folder was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @folder.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /folders/1
  # DELETE /folders/1.json
  def destroy
    if bm = @folder.bookmark
       bm.folder_id = nil
       bm.save
    end
    @folder.destroy
    respond_to do |format|
      format.html { redirect_to folders_url }
      format.json { head :no_content }
    end
  end

# change storage
  def changeStorage
     @storage = Storage.find(params[:storage_id])
     op = @storage.originPath
     fp = @folder.originPath
     old_storage_id = @folder.storage.id

     if fp[op]
       @folder.mpath = fp.sub(op, "")
       @folder.storage_id = @storage.id
       @folder.save
       @folder.resetFOLDERPATH
     end
    redirect_to storage_path(old_storage_id, move: "x")
  end


# copy files from from origin location to location of type typ

  def copyFiles

    typString = params[:typ]

    if typString
       typ = typString.to_i
       if typ == 1 or typ == 2 or typ == 3 or typ == 4
          toLocation = @folder.storage.location(typ)
          mk = toLocation.mkDirectories(@folder)

          if typ == 3 or typ == 4
            message = @folder.storage.location(1).copyFiles(toLocation,@folder,true)
          else
            message = @folder.storage.originLocation.copyFiles(toLocation,@folder,false, false || true)
          end

          flash[:notice] = message
        end
    end
    redirect_to @folder
  end

  def generateTNs

    @folder.storage.location(4).mkDirectories
    message = @folder.generateTNs(@folder.storage.location(2), @folder.storage.location(4), true, "", 20000)

    flash[:notice] = message

    redirect_to @folder

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_folder
      @folder = Folder.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def folder_params
      params.require(:folder).permit(:storage_id, :mpath, :lfolder, :mfile_id, :storage_id, :dlm)
    end
end
