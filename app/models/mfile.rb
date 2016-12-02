class Mfile < ActiveRecord::Base
  has_and_belongs_to_many :attris
  has_and_belongs_to_many :agroups
  belongs_to :folder
  has_one :location, :dependent => :destroy
  
  def path(typ)
#    if typ == URL_STORAGE_WEBTN  or typ == URL_STORAGE_FSTN #  Thumbnails 
#      p = folder.path(typ)
#      if p[-1,1] == "/"   # ends with / 
#         p +id.to_s+".jpg" # then thumbnails are stored as "id.jpg" on root location
#      else
#         p +filename
#      end
#    else
      p =  folder.path(typ) + ""+ filename
      if pdf? and (typ == URL_STORAGE_WEBTN  or typ == URL_STORAGE_FSTN)
        p.gsub!(".pdf", ".jpg")
      end
      p
 #   end
  end
  def name
    if mtype == MFILE_LOCATION
      location.name
    else
      filename
    end
  end
  
  def furlder
    if mtype == MFILE_LOCATION
      location.uri
    else
       folder.lfolder
    end
  end
  
  def pic?    
    name.end_with?("jpg") || name.end_with?("gif") ||  name.end_with?("jpeg") || name.end_with?("JPG")
  end
  
  def pdf?
     name.end_with?("pdf") || name.end_with?("PDF")
  end
  
  def mp3?
     name.end_with?("mp3") || name.end_with?("MP3")
  end
  
end
