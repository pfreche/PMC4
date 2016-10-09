class BookmarksController < ApplicationController
  before_action :set_bookmark, only: [:show, :edit, :update, :destroy, :getTitle, :scan]

  # GET /bookmarks
  # GET /bookmarks.json
  def index
    @bookmarks = Bookmark.all
  end

  # GET /bookmarks/1
  # GET /bookmarks/1.json
  def show
  end

 # GET /bookmarks/1/scan
  # GET /bookmarks/1.json
  def scan
    redirect_to match_scanners_path(url: @bookmark.url)
    # @scanners = Scanner.all
    # scanID = params[:scanID]
    # if scanID
    #     @scanner = Scanner.find(scanID)
    #     @links = RHandler.extract(@bookmark.url, "HREF", @scanner.pattern)
    # end
  end

  # GET /bookmarks/new
  def new
    @bookmark = Bookmark.new
  end

  # GET /bookmarks/1/edit
  def edit
  end

  # POST /bookmarks
  # POST /bookmarks.json
  def create
    @bookmark = Bookmark.new(bookmark_params)

    respond_to do |format|
      if @bookmark.save
        format.html { redirect_to @bookmark, notice: 'Bookmark was successfully created.' }
        format.json { render :show, status: :created, location: @bookmark }
      else
        format.html { render :new }
        format.json { render json: @bookmark.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /bookmarks/1
  # PATCH/PUT /bookmarks/1.json
  def update
    respond_to do |format|
      if @bookmark.update(bookmark_params)
        format.html { redirect_to @bookmark, notice: 'Bookmark was successfully updated.' }
        format.json { render :show, status: :ok, location: @bookmark }
      else
        format.html { render :edit }
        format.json { render json: @bookmark.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bookmarks/1
  # DELETE /bookmarks/1.json
  def destroy
    @bookmark.destroy
    respond_to do |format|
      format.html { redirect_to bookmarks_url, notice: 'Bookmark was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

# get Title from URl by retrieving the url / implemented as AJAX

  def getTitle

    uri = URI.parse(@bookmark.url)
    begin
#      response = Net::HTTP.get_response(uri)
      page = Nokogiri::HTML(open(@bookmark.url))
      @title = page.css("title")[0].text
    rescue StandardError
      @title = "site not available: " + @bookmark.url
    end
    render plain: @title
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bookmark
      @bookmark = Bookmark.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def bookmark_params
      params.require(:bookmark).permit(:title, :url, :description)
    end
end
