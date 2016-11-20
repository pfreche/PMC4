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
  

 def mkDirectories
   
# check types   
   return "wrong typ in toLocation"    unless typ == URL_STORAGE_FS  or typ == URL_STORAGE_FSTN
   
# get all folder from storage

   folders = storage.folders
   
   folders.each do |folder|
     f = uri + "/"+ folder.mpath + "/" + folder.lfolder
     
     fsplit = f.split(/\//)
     fr = ""
     fsplit.each do |fs|
       next if fs == ""
       fr = File.join(fr,fs)
       puts "'"+f+"'"
       puts "dir='"+fr+"'"
       unless File.exist?(fr) 
          Dir.mkdir(fr)
       end
     end
   end
 
 end



   def copyFiles(toLocation, folder = nil, force = false) # force implementierung fehlt noch für File Copy
 
     if folder == nil
     end
     if folder.is_instance_of (Folder)    
     end
     

   end 

end
