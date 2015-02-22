class Folder < ActiveRecord::Base
  belongs_to :storage
  has_many :mfiles,  :dependent => :destroy
  
  def path(typ)
    
   if FOLDERPATH[typ] == nil 
       Folder.setFolderPath(typ)
  end
    FOLDERPATH[typ][id] 

  end
  def Folder.setFolderPath(typ)
      FOLDERPATH[typ] = nil
      FOLDERPATH[typ] = Hash.new 
      fp = Folder.all
      fp.each do |f|
        storage = f.storage
        next unless storage
        
        ppath = storage.path(typ)
        location = storage.location(typ)
        
        next unless location  #  important if a location for a certain type has not been defined
       
        if typ == URL_STORAGE_WEBTN or typ == URL_STORAGE_FSTN
          tnprefix = location.prefix
          if tnprefix && !tnprefix.empty?
              a =  ppath+ "/" +  f.mpath + "/" +  f.lfolder + "/" + tnprefix
          else
             a =  ppath+ "/"  # relevant for thumbnails path in the old fashion
          end
        else 
          a =  ppath+ "/" +  f.mpath + "/" +  f.lfolder + "/"
          
        end 
        
        FOLDERPATH[typ][f.id]=  a.gsub("//", "/").gsub("//", "/").gsub("http:/","http://")
      end
  end
  
  def Folder.resetFOLDERPATH()
    FOLDERPATH.map! {|x| nil}  # puh, jetzt gehts
  end

  # ppath = storage.path(typ)
  #
  # a =  ppath+ "/" +  mpath + "/" +  lfolder
  # a.gsub("//", "/").gsub("//", "/")
end
