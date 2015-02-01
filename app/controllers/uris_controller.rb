class UrisController < ApplicationController

def show
  
end


def matchDir
  
  @path = params[:path]
  @filter = params[:filter]  
  files = UriHandler.getFiles(@path,@filter)
  @links = UriHandler.match(files)
  
  render "match"
end


def matchURL
  
  @path = params[:path]
  @filter = params[:filter]
  @save = params[:save]  
  files = UriHandler.getLinks(@path,@filter)
  @links = UriHandler.match(files)
  
  if  @save
    UriHandler.save(@links, MFILE_UNDEFINED)
  end
  render "match"
end

def save
    @path = params[:path]
  @filter = params[:filter]
    
  files = UriHandler.getFiles(@path,@filter)
  @links = UriHandler.match(files)
  
  
  
end

end


