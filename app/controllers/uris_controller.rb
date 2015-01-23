class UrisController < ApplicationController

def show
  
end


def match
  
  @path = params[:path]
  
  files = UriHandler.getFiles(@path,"")
  @links = UriHandler.match(files)
end


end


