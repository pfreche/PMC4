require 'open-uri'

class Folder < ActiveRecord::Base
  belongs_to :storage
  has_many :mfiles,  :dependent => :destroy
  

  def originPath
    ppath = storage.originPath
    a =  ppath+ "/" +  mpath + "/" +  lfolder + "/"
    a.gsub("//", "/").gsub("//", "/").gsub("http:/","http://")
  end

  def path(typ)
    
    if FOLDERPATH[typ] == nil 
       Folder.setFolderPath(typ)
    end
    if FOLDERPATH[typ][id] == nil
       setFolderPath(typ)
    end

    FOLDERPATH[typ][id] 
  end
   
  def setFolderPath(typ)
        
        return unless storage
        
        ppath = storage.path(typ)
        location = storage.location(typ)
        return unless location  #  important if a location for a certain type has not been defined
        a =  ppath+ "/" +  mpath + "/" +  lfolder + "/"
        FOLDERPATH[typ][id]=  a.gsub("//", "/").gsub("//", "/").gsub("http:/","http://")

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
          if (tnprefix && !tnprefix.empty?) or true # CHANGE 25.02.2015
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
 
  def mkdir_DISABLED(toLocation)

     toStorage = toLocation.storage
     if toStorage != storage
      return
     end 
     uri = toLocation.uri
   
# check types   
     return "wrong typ in toLocation"   unless toLocation.typ == URL_STORAGE_FS  or toLocation.typ == URL_STORAGE_FSTN
   
     f = uri + "/"+ mpath + "/" + lfolder
     
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


 def copyFiles(fromLocation, toLocation, force = false) # force implementierung fehlt noch für File Copy
   
   toStorage = toLocation.storage
   return "different storages" unless fromLocation.storage == toStorage
   
   return "folder is in different storage" unless toStorage.id == storage.id

   toUri = toLocation.uri
   fromUri = fromLocation.uri
# check types
#  return "wrong typ in fromLocation"  unless fromLocation.typ == URL_STORAGE_FS  or fromLocation.typ == URL_STORAGE_FSTN
   return "wrong typ in toLocation"    unless toLocation.typ == URL_STORAGE_FS  or toLocation.typ == URL_STORAGE_FSTN
   # todo: check FS or FSTN in common?
   

# get all folder from storage - fromLocation

   n = 0
  
   from = File.join(fromUri, mpath, lfolder).gsub("//", "/").gsub(":/","://")
   to =   File.join(toUri, mpath, lfolder)
     
#   mfiles = folder.mfiles
     
   mfiles.each do |mfile|           
        fromFile = File.join(from,mfile.filename)
        toFile   = File.join(to,mfile.filename)
        
        next if File.exist?(toFile) and not force # 20160108 

        x = toFile.split(/\//)
        checkpath  = "/"
        x = x[0,x.length-1]
        x.each {|p| checkpath = checkpath + "/" + p 
           unless File.exist?(checkpath)
             Dir.mkdir(checkpath)
           end          
        }

        if fromLocation.typ == URL_STORAGE_WEB           
              uri = URI.parse(URI.encode(fromFile))
              req = Net::HTTP::Get.new(uri.request_uri)
              req['Referer'] = uri.scheme+"://"+uri.host
              Net::HTTP.start(uri.host, uri.port) do |http|
                  response = http.request(req)
                 open(toFile, "wb") do |file|
                     file.write(response.body)
                     n = n +1
                 end
              end
        end
        
        if fromLocation.typ == URL_STORAGE_FS
          if File.exist?(fromFile) 
             FileUtils.cp(fromFile, toFile)
             n = n +1
          end
        end     
      break if n >20
   end
   return n.to_s+ " files copied"
 end


def generateTNs(fromLocation, toLocation, force=true, prefix, area)
   
   toStorage = toLocation.storage
   return "different storages" unless fromLocation.storage == toStorage
   toUri = toLocation.uri
   fromUri = fromLocation.uri
# check types
   return "wrong typ in fromLocation"  unless fromLocation.typ == URL_STORAGE_FS  
   return "wrong typ in toLocation"    unless toLocation.typ == URL_STORAGE_FSTN
   
   n = 0
   
   from = File.join(fromUri, mpath, lfolder)
   to =   File.join(toUri, mpath, lfolder)
     
     
   mfiles.each do |mfile|
        tofile = File.join(to,prefix+mfile.filename)
        next unless force or !File.exist?(tofile)  # 
        
        fromfile = File.join(from,mfile.filename)
       
        case 
        when mfile.pic?
           if area == 0 
              command = "jhead -st \"" + tofile + "\"  \"" + fromfile  +"\""
           else
              command = "convert \""+ fromfile + "\" -thumbnail "+area.to_s+"@ \""+ tofile+"\""
           end
        when mfile.pdf?
              tofile = tofile.gsub(".pdf",".jpg").gsub(".PDF",".jpg")
              are = (area==0)?20000:area
              command = "convert \""+File.join(from,mfile.filename)+ "\"[0] -thumbnail "+are.to_s+"@ \""+ tofile+"\""
        else 
             command = nil
        end
        
        if command
           puts command
           system(command)
        end
        n = n + 1
   end
   return n.to_s+" thumbnails generated"
 end



def next
    f = Folder.where(storage_id: storage_id).where('id >?', id).first
    if f
      return f
    else
      return  Folder.where(storage_id: storage_id).first
    end
  end

  def previous
    f = Folder.where(storage_id: storage_id).where('id <?', id).order(id: :desc).take
    if f
      return f
    else
      return  Folder.where(storage_id: storage_id).last
    end
  end
  
end
