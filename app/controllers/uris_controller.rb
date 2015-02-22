class UrisController < ApplicationController

def show
  
end

def fetch
  
  @path = params[:path]
  @filter = params[:filter]  
  @save = params[:save] 
  @act = params[:act]
  @commit = params[:commit]
    
  if @act == "matchDir"
      files = UriHandler.getFiles(@path,@filter)
  end
  
  if @act == "matchURL"
      files = UriHandler.getLinks(@path,@filter)
  end
  
  @links = UriHandler.match(files)
  
  if  @save or  @commit == "Save" 
    UriHandler.save(@links, MFILE_UNDEFINED)
  end

  render "match"
  
end



def matchDir
  
  @path = params[:path]
  @filter = params[:filter]  
  @save = params[:save] 
  @action = params[:action]
    
  
  files = UriHandler.getFiles(@path,@filter)
  @links = UriHandler.match(files)
  if  @save
    UriHandler.save(@links, MFILE_UNDEFINED)
  end
  @action = "matchDir"
  render "match"
end


def matchURL
  
  @path = params[:path]
  @filter = params[:filter]
  @save = params[:save]  
  @action = params[:action]
  @commit = params[:commit]
  
  files = UriHandler.getLinks(@path,@filter)
  @links = UriHandler.match(files)
  
  if  @save or  @commit == "Save" 
    UriHandler.save(@links, MFILE_UNDEFINED)
  end
  @action = "matchURL"
  render "match"
end


def save
    @path = params[:path]
  @filter = params[:filter]
    @action = parmams[:action]
    
  files = UriHandler.getFiles(@path,@filter)
  @links = UriHandler.match(files)
  
  
  
end

end


