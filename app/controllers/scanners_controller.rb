class ScannersController < ApplicationController
  before_action :set_scanner, only: [:show, :edit, :update, :destroy, :scann]

  # GET /scanners
  # GET /scanners.json
  def index
    @scanners = Scanner.all
  end

  def match
    @url = params[:url]
    @scanners = Scanner.all
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
    @links = RHandler.extract(@url,@scanner.tag,@scanner.attr,@scanner.pattern) 
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
      params.require(:scanner).permit(:tag, :attr, :pattern, :scan, :url, :name, :match)
    end
end
