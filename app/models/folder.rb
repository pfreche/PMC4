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
        ppath = storage.path(typ)
        location = storage.location(typ)
        if typ != URL_STORAGE_WEBTN
          a =  ppath+ "/" +  f.mpath + "/" +  f.lfolder
        else 
#          if tnprefix = location.tnprefix 
#            a =  ppath+ "/" +  f.mpath + "/" +  f.lfolder + "/" + tnprefix
 #         else
             a =  ppath+ "/"  # relevant for thumbnails path in the old fashion
#         end
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
