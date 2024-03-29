class Mfile < ActiveRecord::Base
  serialize :filename # fix for issue with UTF8 with only 3 bytes issue in mysql

  has_and_belongs_to_many :attris
  has_and_belongs_to_many :agroups
  belongs_to :folder
  has_one :location, :dependent => :destroy
  has_one :bookmark, :dependent => :destroy

  def path(typ)
#    if typ == URL_STORAGE_WEBTN  or typ == URL_STORAGE_FSTN #  Thumbnails
#      p = folder.path(typ)
#      if p[-1,1] == "/"   # ends with /
#         p +id.to_s+".jpg" # then thumbnails are stored as "id.jpg" on root location
#      else
#         p +filename
#      end
#    else
      if folder
        if (typ == URL_STORAGE_FS  or typ == URL_STORAGE_FSTN)
           p =  File.join(folder.path(typ), filename) #   typ <> web
        else
           p =  File.join(folder.path(typ), URI.escape(filename)) #  typ == web
        end

        if (typ == URL_STORAGE_WEBTN  or typ == URL_STORAGE_FSTN)
#          p.gsub!(".pdf", ".jpg")
           p.gsub!(/\.[\w]*$/, ".jpg")  # Assuming Thumbnails to be always jpg's 
        end
        
        p
     else
        "<no folder>"
     end
  end

  def originPath
    p =  folder.originPath + ""+ filename
    if pdf? and (typ == URL_STORAGE_WEBTN  or typ == URL_STORAGE_FSTN)
      p.gsub!(".pdf", ".jpg")
    end
    p
  end

  def name
    if mtype == MFILE_LOCATION
      location.name+" *"
    else
      if mtype == MFILE_BOOKMARK
         bookmark.title+" *"
      else
        filename
      end
    end
  end

  def furlder
    if mtype == MFILE_LOCATION
      location.uri+" *"
    else
      if mtype == MFILE_BOOKMARK
         bookmark.url+" *"
      else
         if folder
           folder.mpath + folder.lfolder
         else
          "xxxxxxxxxxxxx"
         end
      end
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

  def mtypee
     mtype == 0 ? folder.storage.mtype : 0
  end
  
  def youtubeLink
    
     fwo = filename.gsub(/\.[\w]*$/, "")[-11..-1]  
     if fwo
       youtube_id = fwo[-11..-1]  
       "https://www.youtube.com/watch?v="+youtube_id
       "https://www.youtube.com/embed/"+youtube_id
      else
        "n/a"
      end
  end

end
