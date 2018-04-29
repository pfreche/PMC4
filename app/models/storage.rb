class Storage < ActiveRecord::Base
  has_many :locations
  has_many :folders,  :dependent => :destroy # too risky

  def originLocation
   locations.where(storage_id: id).where(origin: true).first
  end

  def originPath
     originLocation ? originLocation.uri : nil
  end

  def webLocation
   locations.where(storage_id: id).where(inuse: true, typ: 1).first
  end
  
  def location(typ)
     locations.where(storage_id: id).where(inuse: true, typ: typ).first
  end
  
  def path(typ)
    if l = location(typ)
      l.uri      
    else
          ""
    end
  end
  
  def touchMfiles
    @mfiles = getMfiles
    
    @mfiles.each do |mfile|

            modtime = File.new(mfile.path(URL_STORAGE_FS)).mtime
            mfile.modified = modtime
            mfile.mod_date = modtime
            mfile.save
    end
  end
  
  def getMfiles
    Mfile.joins(:folder => :storage).where("storages.id = ?", id).distinct.to_a
  end
end
