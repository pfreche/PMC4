class ScannersController < ApplicationController
  before_action :set_scanner, only: [:show, :edit, :update, :destroy, :scann]

  # GET /scanners
  # GET /scanners.json
  def index
    @scanners = Scanner.all
    @scanners = @scanners.sort {|a,b| a.url <=> b.url} 
  end

  def match

    @url = params[:url]
    @bookmark_id = params[:bookmark_id]
    @urly = Urly.new(@url)
    location_id = params[:location_id]
    @location = Location.find(location_id) if location_id
    if  params[:commit] == "Match and Scan"
      matchAndScan
    end
    @scanners = Scanner.all
    @scanners = @scanners.sort {|a,b| b.matchS(@url).to_s+a.url <=> a.matchS(@url).to_s+b.url} 

  end

  def matchAndScan
    @url = params[:url]
    @bookmark_id = params[:bookmark_id]
    
    @links = Scanner.matchAndScan(@url)
    if @links.select{|a,b| b[1]=="YT"}.empty?
     
      @commonStart = Scanner.detCommonStart(@links)
      @possibleLocations = Location.all.select{|l| @commonStart.include? l.uri} # besser auf der DB ???
      render :scanResult
    else 
      @possibleLocations = Location.all.where(typ: 2)
      render :scanResultYT     
    end

  end

  def msytdl # match scan youtube download
    @url = params[:url]
    @links = Scanner.matchAndScan(@url)
     location_id = params[:location_id]
     location = Location.find(location_id)

    user, x = @links.select{|a,b| b[1]=="user"}.first
    title, x = @links.select{|a,b| b[1]=="title"}.first
    folder = Scanner.createFolder("/"+user, title,location)
    location.downloadTube(folder, @url)    

  end

  def msas # match scan and save
     @url = params[:url]
     @bookmark_id = params[:bookmark_id]
     location_id = params[:location_id]
     if location_id and @url
       @location = Location.find(location_id)
       @links = Scanner.matchAndScan(@url)
       folder = Scanner.createFolderAndMfiles(@url,@links,@location)
       if @bookmark_id
         bm = Bookmark.find(@bookmark_id)
         bm.folder_id = folder.id
         bm.title = folder.title
         bm.save
       else
         bm = Bookmark.new(url: @url, folder_id: folder.id, title: folder.title)
         bm.save
        end
       redirect_to folder_path(folder)
     else

     end
  end

  # GET /scanners/1
  # GET /scanners/1.json
  def show
  end

  # GET /scanners/new
  def new
       @scanner = Scanner.new
  end

  # GET /scanners/new
  def copy
     if params[:id]
       @scanner = Scanner.find(params[:id]).dup
       @scanner.url = params[:urlExtern] if params[:urlExtern] 
     else
       @scanner = Scanner.new
    end
     render :new
  end

  # GET /scanners/1/edit
  def edit
  end

  def scann
    @url = params[:url]
#      @links = RHandler.extract(@url,@scanner.tag,@scanner.attr,@scanner.pattern) 
   #  @links = RHandler.scanAndMatch(@url,2)
      @links = @scanner.scan(@url)
  end

  def scan
    if params[:scanner]
       @scanner = Scanner.new(scanner_params)

       if  params[:commit] == "Scan"   
         @links = RHandler.extract(@scanner.url,"a",@scanner.pattern) 
       else 
         @scanner.save
          redirect_to @scanner, notice: 'Scanner was successfully created.'
       end
    else
       @scanner = Scanner.new
    end
  end 


  # POST /scanners
  # POST /scanners.json
  def create
    @scanner = Scanner.new(scanner_params)

    respond_to do |format|
      if @scanner.save
        
        format.html { redirect_to @scanner, notice: 'Scanner was successfully created.' }
        format.json { render :show, status: :created, location: @scanner }
      else
        format.html { render :new }
        format.json { render json: @scanner.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /scanners/1
  # PATCH/PUT /scanners/1.json
  def update
    respond_to do |format|
      if @scanner.update(scanner_params)
        if  params[:commit] == "Scan"   
           @links = RHandler.extract(@scanner.url,@scanner.tag,@scanner.attr, @scanner.pattern) 
        end
        format.html { render :edit, notice: 'Scanner was successfully updated.' }
        format.json { render :show, status: :ok, location: @scanner }
      else
        format.html { render :edit }
        format.json { render json: @scanner.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /scanners/1
  # DELETE /scanners/1.json
  def destroy
    @scanner.destroy
    respond_to do |format|
      format.html { redirect_to scanners_url, notice: 'Scanner was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_scanner
      @scanner = Scanner.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def scanner_params
      params.require(:scanner).permit(:tag, :attr, :pattern, :scan, :url, :location, :name, :match, :final, :stype)
    end
end
