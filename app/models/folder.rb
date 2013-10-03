class Folder < ActiveRecord::Base
  belongs_to :storage
  has_many :mfiles
  def path(typ)
    
    if FOLDERPATH[typ] == nil
       Folder.setFolderPath(typ)
    end
    FOLDERPATH[typ][id] 

  end
  def Folder.setFolderPath(typ)
      FOLDERPATH[typ] = nil
      FOLDERPATH[typ] = Array.new 
      fp = Folder.all
      fp.each do |f|
        ppath = f.storage.path(typ)
        if typ != 3
          a =  ppath+ "/" +  f.mpath + "/" +  f.lfolder
        else 
           a =  ppath+ "/" 
        end 
        FOLDERPATH[typ][f.id]=  a.gsub("//", "/").gsub("//", "/").gsub("http:/","http://")
      end
  end

  # ppath = storage.path(typ)
  #
  # a =  ppath+ "/" +  mpath + "/" +  lfolder
  # a.gsub("//", "/").gsub("//", "/")
end
