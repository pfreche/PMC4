class StoragesController < ApplicationController
  before_action :set_storage, only: [:show, :edit, :update, :destroy]
  # GET /storages
  # GET /storages.json
  
# =>  FILEPATH=55
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

 # Detect Folders for a storage
  # 
  def detectfolders
 
    @storage_id = params[:id]
    save = params[:save]
    
    @storage = Storage.find(@storage_id)
    @basepath = @storage.path(URL_STORAGE_FS) # take the filepath
    
    a = []
    get_all_folders("", "", a)
    @folders = a    
    
  #  render text: @folders.map {|a| a.lfolder+"/"+a.mpath}
    if  save == "yes"
      if !@folders.nil?
          Folder.resetFOLDERPATH
 #        Folder.setFolderPath(55)
          success = true
      for folder in @folders
        success = success & folder.save
      end
      if success
        flash[:notice] = 'Folders successfully added.'
      else
        flash[:notice] = 'Error occured during adding Folders.'
      end
    else
      flash[:notice] = 'No files to be added.'      
    end
    end


  end
  
  # Detect files in folders
  # 
  def detectfiles
    @storage_id = params[:id];
    filter = params[:filter]
    if filter == nil
      filter = /./
    end

    @storage = Storage.find(@storage_id)
    folders = Folder.where(storage_id: @storage_id)
    
    @mfiles = []    
    for folder in folders
      fp = folder.path(URL_STORAGE_FS) # filepath
      d = Dir.entries(fp)
      @mfiles_temp = []
      for file in d
        if file == '.' or file == '..'
          next
        end
        if file =~ filter
        else 
          next
        end
        
        if File.directory?(fp+"/"+file)
        else
          if Mfile.find_by_folder_id_and_filename( folder.id, file)
          else
            mfile = Mfile.new()
            mfile.folder_id = folder.id
            mfile.filename = file
            modtime = File.new(mfile.path(URL_STORAGE_FS)).mtime
            mfile.modified = modtime
            mfile.mod_date = modtime
            mfile.type = MFILE_PHOTO # should be replaced by dependency of storage type
            @mfiles_temp << mfile
            #            @mfiles << mfile
          end
        end
      end
      if @mfiles_temp != nil
        #       puts @mfiles_temp[0].path(1)
        @mfiles_temp.sort! {|x,y| x.filename <=> y.filename}
        @mfiles += @mfiles_temp     
      end 
    end
    if @mfiles.nil?
      flash[:notice] = 'No new files detected.'  
    end
    
    if params[:save] == "yes"
      
      if !@mfiles.nil?
      success = true
      for mfile in @mfiles
        success = success & mfile.save
      end
      if success
        flash[:notice] = 'Media Files successfully added.'
      else
        flash[:notice] = 'Error occured during adding Media Files.'
      end
    end
    end
    
  end
  
  # generate the thumbnails for a given storage
 
  def make_thumbnails
 
    @height = params[:height]
    @width = params[:width]
    @complete = params[:complete]
    @embedded = params[:embedded]
    @embedded = true
    @complete = true
       
    @storage_id = params[:id];
    @storage = Storage.find(@storage_id)
    
 #   fol = @storage.path(URL_STORAGE_FSTN)+"/"
    
    folders = @storage.folders
    
    if @embedded      # use embeded thumbnail pictures
      ja = "jhead -st "
    else             # generate thumbnails via java Thumbnail class
      ja = "java Thumbnail "
    end
    n = 0
    
    str = []
    
    for folder in folders
      
      mfiles = folder.mfiles
      for mfile in mfiles
        if @complete  || !File.exist?(mfile.path(URL_STORAGE_FSTN))

          if @embedded
             str[n] = ja + "\"" + mfile.path(URL_STORAGE_FSTN) + "\" "  +  "\""+ mfile.path(URL_STORAGE_FS) +"\"" 
 #            str[n] = ja + "\"" + fol + mfile.id.to_s + ".jpg\" " + "\""+ mfile.path(URL_STORAGE_FS) +"\"" 
               # leere Verzeichnsisstruktur erstellen geht mit:  xcopy e:\ c:\ /s/t 
             p str[n]
          else
            str[n] = ja + "\""+ mfile.path(URL_STORAGE_FS) +"\" \""+ fol + mfile.id.to_s + ".jpg\" "  +
            @width.to_s +  " " + @height.to_s + " 90"
          end
          puts str[n]
          n = n + 1
        end
      end
    end
    
 
 #   Thread.new do
      nn = 0
#      Thread.current[:no] = str.length
      session[:no_tns] = 0
      str.each do |st|
        nn = nn + 1
        system(st)        
#        Thread.current["nn"] = nn         
      end
#    end   
    redirect_to :action => 'index' 
    
  end
  
  
  private
  
  #------------------------------------------------
  
  
  def get_all_folders (mpath, lfolder, folders)
    if mpath == ""
      path = lfolder
    else
      path = mpath + "/" + lfolder
    end
    
    if path == ""
      complete_path = @basepath 
    else
      complete_path = @basepath + "/" + path
    end
    
    if complete_path == @storage.filepath_tn
      return
    end    
    
    d = Dir.entries(complete_path)
    # files
    for file in d
      if file == '.' or file == '..'
        next
      end
      if File.directory?(complete_path+"/"+file)
      else # it's a file and not a directory, therefore at least one file is in the directory
        
        if folder = Folder.find_by_storage_id_and_mpath_and_lfolder( @storage_id,
                                                           mpath,
                                                           lfolder)
           folders << folder
        else
          folder = Folder.new()
          folder.storage_id = @storage_id
          folder.mpath = mpath
          folder.lfolder = lfolder
          
          folders << folder
          
        end
        break # directory (containing at least one filed) is collected; go to the next entry.
      end
    end
    
    
    # subdirs
    for file in d
      if file == '.' or file == '..'
        next
      end
      if File.directory?(complete_path+"/"+file)
        get_all_folders(path, file, folders)
      end
    end
    
    return folders
  end



  # Use callbacks to share common setup or constraints between actions.
  def set_storage
    @storage = Storage.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def storage_params
    params[:storage].permit(:name, :path)
  end
end
