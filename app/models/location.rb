require 'net/http/post/multipart'

class Location < ActiveRecord::Base

  belongs_to :storage
  belongs_to :mfile

  Tempfile = "./tmp/tempfile"
  
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
   
# get all folder from storage
  folders = storage.folders 
   a = ""
# check types   
  if typ == URL_STORAGE_FS  or typ == URL_STORAGE_FSTN
   
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
  
  else
    onetime = true
    folders.each do |folder|
      f = uri + "/"+ folder.mpath + "/" + folder.lfolder
      fsplit = f.split(/\//)
      ur = ""
      fsplit.each do |fs|
        next if fs == "" 
        urLast = ur
        if fs == "http:"
          ur = "http://"
          next
        end
        ur = File.join(ur,fs)+"/"
        next if ur  == "http://" or ur =~ /http:\/\/[^\/]+\/$/
        if (u= uriResponseCode(ur)) == "404" 
          
          s = uriMkdir(urLast,fs)
          return false unless s 
          onetime = false
          qrq
        end
      end
    end
  end
  true
end

def createDirsIfNecessary(toFile, toWeb=false)
 
    if toWeb

      if uriResponseCode(toFile) != "404" # file or directory does  exist 
         return 0
      end
      
      fsplit = toFile.split(/\//)
      ur = ""
      firstFolderCreated = false
      first = true
      fsplit.each do |fs|
        next if fs == "" 
        urLast = ur
        if fs == "http:"
          ur = "http://"  # as all / were removed in the split command
          next
        end
        ur = File.join(ur,fs)+"/"
        next if ur  == "http://" or ur =~ /http:\/\/[^\/]+\/$/
        return 1 if ur.length >= toFile.length
        if firstFolderCreated or uriResponseCode(ur) == "404"           
          s = uriMkdir(urLast,fs)
          return -1 unless s 
          firstFolderCreated = true
        end
      end
    else # to file
    end
end 


def uriExist?(x)
  response = nil
   return true if  x == "http://" 
  uri = URI(x)
  Net::HTTP.start(uri.host, uri.port) {|http|
    response = http.head(uri.path)
  }
  !(response.code == "404")
end

def uriResponseCode(x)
  response = nil
  uri = URI(x)
  Net::HTTP.start(uri.host, uri.port) {|http|
    response = http.head(uri.path)
  }
  response.code
end

def uriMkdir(url, folder)

  uri = URI(url+"?mode=section&id=ajax.mkdir")
  res = Net::HTTP.post_form(uri, 'name' => folder)
  res.code != "404"
end

  def copyFiles(toLocation, folder = nil, force = false) # force implementierung fehlt noch für File Copy
 
     @force = force

     toStorage = toLocation.storage
     return "different storages" unless storage == toStorage
     if folder == nil
       folders = storage.folders
     else 
       return "folder does not belong to the storage" unless storage == folder.storage 
       folders = [folder]
     end

     fromUri = uri
     toUri = toLocation.uri
 
     n = 0
    
     folders.each do |f|
  
       from = folder.pathLocation(self)
       to =   folder.pathLocation(toLocation)

        f.mfiles.each do |mfile|
          fromFile = File.join(from,mfile.filename)
          toFile   = File.join(to,mfile.filename)     
          if copyFile(fromFile, toFile)
             n = n + 1
          end
        end
     end
    n
   end 

  def copyFile (fromFile, toFile)
     
     return unless @force or !uriExist?(toFile)
#     return if not @force and exist?(toFile)

     fromWeb = (fromFile[0,4]=="http")
     toWeb   = (toFile[0,4]=="http")

     return false if createDirsIfNecessary(toFile,toWeb) < 0

     if fromWeb
          toFileWrite = toWeb ? Tempfile : toFile 

          uri = URI.parse(URI.encode(fromFile))
          req = Net::HTTP::Get.new(uri.request_uri)
          req['Referer'] = uri.scheme+"://"+uri.host

          Net::HTTP.start(uri.host, uri.port) do |http|
              response = http.request(req)
              
              open(toFileWrite, "wb") do |file|
                  file.write(response.body)
              end
          end
          if toWeb
             upload Tempfile, toFile
          end
     else # from FileSystem
        if toWeb
           upload fromFile, toFile
        else # to FileSystem
          if File.exist?(fromFile) 
             FileUtils.cp(fromFile, toFile)
          end
       end
     end 
  end

private

# uploads a file locally stored in Tempfile to HFS-Webserver 
  def upload(fromFile,toWebFile)

        filename = File.basename(toWebFile)
        ur = File.dirname(toWebFile)
        url = URI.parse(ur)

        req = Net::HTTP::Post::Multipart.new url.path, 
            "file1" => UploadIO.new(File.new(fromFile), "image/jpeg", filename)

        res = Net::HTTP.start(url.host, url.port) do |http|
               http.request(req)
        end
  end

end
