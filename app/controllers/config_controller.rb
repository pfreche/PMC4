class ConfigController < ApplicationController

  
  # GET /agroups/1
  # GET /agroups/1.json
  def show
    Business::Logic.dlm= Business::Logic.dlm() +1
    
    render :text =>      Business::Logic.dlm

  end

  # GET /agroups/new
  def new
  end

  # GET /agroups/1/edit
  def edit
  end

end
