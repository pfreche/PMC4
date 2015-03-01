class Location < ActiveRecord::Base
  belongs_to :storage
  belongs_to :mfile
  
  def isFS?    
    typ == URL_STORAGE_FS or typ == URL_STORAGE_FSTN
  end
  
  def isWeb?
        typ == URL_STORAGE_WEB or typ == URL_STORAGE_WEBTN or typ== URL_WEB 
  end
  
  def isStorage?
        typ != URL_WEB 
  end
  
  def copyAllowedTo?
     isFS? and (locationFrom = storage.location(typ))  and !(self == locationFrom)
  end
  
  def downloadAllowedTo?
     isFS? and ((storage.location(URL_STORAGE_WEB)  and (typ == URL_STORAGE_FS))          or (storage.location(URL_STORAGE_WEBTN)  and (typ == URL_STORAGE_FSTN )))
  end
  
  
end
