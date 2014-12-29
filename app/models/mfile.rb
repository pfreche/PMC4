class Mfile < ActiveRecord::Base
  has_and_belongs_to_many :attris
  has_and_belongs_to_many :agroups
  belongs_to :folder
  def path(typ)
    if typ == URL_STORAGE_WEBTN  or typ == URL_STORAGE_FSTN #  Thumbnails 
      p = folder.path(typ)
      if p[-1,1] == "/"   # ends with / --> thnumbnails are sto
         p +id.to_s+".jpg" # then thumbnails are stored as "id.jpg" on root location
      else
         p +filename
      end
    else
      folder.path(typ) +filename
    end
  end
end
