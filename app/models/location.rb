require 'net/http/post/multipart'

class Location < ActiveRecord::Base

  belongs_to :storage
  belongs_to :mfile

#  Tempfile = "./tmp/tempfile"

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

def ls(dir = "")
    files = []
    path = uri
    d = File.join(path,dir,"/*")
    Dir.glob(d) {|f|
       files << [f,File.directory?(f)]
      }
     a=  ActionController::Base.helpers.link_to "a", "b"
    files
  
end

# 20171015 Scans files physically
def scan (filter = nil, dir)

    dir = dir||""
    path = File.join(uri,dir,"/**/*")
    uriLength = File.join(uri,"/").length
    files = []
    if filter == nil
      filter  = "."
    end
    Dir.glob(path) {|f|
      if !File.directory?(f) and f[%r{#{filter}}]
        files << f
      end
      }
    k = files.map{|l| l[uriLength..-1]}.map {|l| l.split(/\//)}
    k

end

def scanAndAdd (inlevel, filter = nil, dir)

    files = scan(filter,dir)
    if inlevel == 100
       naturallevel = true
    end
    files.each { |file|

       level = naturallevel ? file.length : inlevel
       unless file[level] # omit files below level 
          file[0] = "LEVEL TOO HIGH: Skipped "+file[0]
          next 
       end
       path = ""
       for i in 1..level
           path = path + "/"+ file[i-1]
       end
       path = path + "/"
       filename = ""

       for i in level..5
           filename = filename + file[i]
           break unless file[i+1]
           filename = filename + "/"
       end
       folder = Folder.where(storage_id: storage_id, mpath: path ).first
       unless folder
         folder = Folder.create(storage_id: storage_id, mpath: path, lfolder: "")
         folder.save
         foldernew = true
       end

       if foldernew or !Mfile.where(folder_id: folder.id, filename: filename).first
         mfile = Mfile.new(folder_id: folder.id, filename: filename, mtype: MFILE_UNDEFINED)
         mfile.save
         file[0] = "ADDED: "+file[0]
       else
         file[0] = "Not Added as already existing: "+file[0]
       end
    }
   files
end



def mkDirectories(folder = nil)

  if folder
     folders = [folder]
  else
     folders = storage.folders
   end
   a = ""

# type switches
  if typ == URL_STORAGE_FS  or typ == URL_STORAGE_FSTN

    folders.each do |folder|

      f = uri +  folder.mpath +  folder.lfolder

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
        ur = ur + fs +"/"
        next if ur  == "http://" or ur =~ /http:\/\/[^\/]+\/$/
        if (u= uriResponseCode(ur)) == "404"

          s = uriMkdir(urLast,fs)
          return false unless s
          onetime = false

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
    else # to file  //TESTED

      if File.exist?(toFile)
        return 0
      end
      fsplit = toFile.split(/\//)
      fr = ""
      fsplit.each do |fs|
        next if fs == ""
        fr = File.join(fr,fs)
        return 1 if fr.length >= toFile.length
        unless File.exist?(fr)
pp
          Dir.mkdir(fr)
        end
      end
      return 1
    end
end


def uriExist?(x)
  response = nil
   return true if  x == "http://"
  uri = URI(URI.encode(x))
  Net::HTTP.start(uri.host, uri.port) {|http|
    response = http.head(uri.path)
  }
  !(response.code == "404")
end

def uriResponseCode(x)
  response = nil
  uri = URI(URI.encode(x))
  Net::HTTP.start(uri.host, uri.port) {|http|
    response = http.head(uri.path)
  }
  response.code
end

def uriMkdir(url, folder)

  uri = URI(url+"?mode=section&id=ajax.mkdir")
  if folder.include?("set")
#     folder = "settle"
  end
  res = Net::HTTP.post_form(uri, 'name' => folder)
  res.code != "404"
end

  def copyFiles(toLocation, folder = nil, tns=false, force ) # force implementierung fehlt noch für File Copy

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
       referer = folder.bookmark.url

        f.mfiles.each do |mfile|
          fromFile = File.join(from,mfile.filename)
          toFile   = File.join(to,mfile.filename)

          if copyFile(fromFile, toFile, tns, referer)
             n = n + 1
          end
        end
     end
#  Download via curl in the background
    if @curl
        Process.spawn(@curl)
    end
    return n
   end

  def copyFile(fromFile, toFile, tns, referer=nil)

    fromWeb = (fromFile[0,4]=="http")
    toWeb   = (toFile[0,4]=="http")
    if @force.is_a? Integer
          if !toWeb and File.exist?(toFile)
             return 0 if File.new(toFile).size > @force
          end
    else
      if !@force
        if toWeb
          return 0 if uriExist?(toFile)
        else
          return 0 if File.exist?(toFile)
        end
      end 
    end

    return false if createDirsIfNecessary(toFile,toWeb) < 0
     copied = false
     if fromWeb
          toFileWrite1 = (toWeb or tns) ? Tempfile.new('t1').path : toFile
          download fromFile, toFileWrite1, 0, referer
          copied = true
     else
         toFileWrite1 = FromFile
     end
     if tns
        toFileWrite2 = toWeb ? Tempfile.new('t2').path : toFile
        generateTNs toFileWrite1, toFileWrite2
        copied = true
      else
        toFileWrite2 = toFileWrite1
     end
     if toWeb
        upload toFileWrite2, toFile
     else
        # copy if not already implicitely happened before
        unless copied
          if File.exist?(fromFile)
             FileUtils.cp(fromFile, toFile)
          end
        end
     end

  end

  def generateTNs(fromLocation, force=true, prefix, area)

    toLocation = self

    toStorage = toLocation.storage
    return "different storages" unless fromLocation.storage == toStorage
    toUri = toLocation.uri
    fromUri = fromLocation.uri

# check types
    return "wrong typ in fromLocation"
         unless fromLocation.typ == URL_STORAGE_FS or fromLocation.typ == URL_STORAGE_WEB
    return "wrong typ in toLocation"    unless typ == URL_STORAGE_FSTN

    n = 0

    from = fromUri +  mpath + lfolder
    to =   toUri   +  mpath + lfolder

    mfiles.each do |mfile|
        tofile = File.join(to,prefix+mfile.filename)
        next unless force or !File.exist?(tofile)  #

        fromfile = from + mfile.filename

        if fromLocation.typ == URL_STORAGE_WEB


        end

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
              command = "convert \"" + fromfile + "\"[0] -thumbnail "+are.to_s+"@ \""+ tofile+"\""
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



  end

def  downloadTube(folder, url)

   apath = "-o \""+ uri + folder.mpath + folder.lfolder + "/%(title)s-%(id)s.%(ext)s\" "
   command = "youtube-dl "+ apath + url
   system(command)
    adf
end

def finish_download
  if @curl
      Process.spawn(@curl)
  end
  @curl = ""
end

# downloads a file from Web to a local file
   def download(fromWebFile, toFile, method=0, referer= nil)
      method = Config::Settings.dlm()
      case method
      when 0
          uri = URI.parse(URI.encode(fromWebFile))
          req = Net::HTTP::Get.new(uri.request_uri)
          if referer == nil
             req['Referer'] = uri.scheme+"://"+uri.host
          else
             req['Referer'] = referer
          end
          Net::HTTP.start(uri.host, uri.port) do |http|
              response = http.request(req)

              open(toFile, "wb") do |file|
                  file.write(response.body)
              end
          end
      when 1
        unless @curl
          uri = URI.parse(URI.encode(fromWebFile))
          if referer == nil
             referer = uri.scheme + "://"+uri.host
          end
#          referer = fromWebFile
          @curl = "curl -e \"" + referer +  "\""
        end
        @curl =  @curl + " -o \""+ toFile + "\" \"" + fromWebFile +  "\""
        c = @curl
      when 2

          uri = URI.parse(URI.encode("http://192.168.178.81:3001/hallo"))
          req = Net::HTTP::Get.new(uri.request_uri)
          q = CGI.escape("http://192.168.178.81:3001")
          uri = "http://192.168.178.81:3001" +"?web="+ CGI.escape(fromWebFile)+"&file="+CGI.escape(toFile)
          uri = uri + "&referer="+CGI.escape(referer) if referer
          a = open(uri).read()
          uri
      end
  end

  # downloads a file from Web to a local file
     def download_with_referer(fromWebFile, toFile, referer, method=1)
        case method
        when 0
            uri = URI.parse(URI.encode(fromWebFile))
            req = Net::HTTP::Get.new(uri.request_uri)
            req['Referer'] = referer

            Net::HTTP.start(uri.host, uri.port) do |http|
                response = http.request(req)

                open(toFile, "wb") do |file|
                    file.write(response.body)
                end
            end
        when 1
          unless @curl
            uri = URI.parse(URI.encode(fromWebFile))
  #          referer = uri.scheme + "://"+uri.host
  #          referer = fromWebFile
            @curl = "curl -e \"" + referer +  "\""
          end
          @curl =  @curl + " -o \""+ toFile + "\" \"" + fromWebFile +  "\""
          c = @curl
  #        adfa
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

  def generateTNs (fromFile, toFile, force = false, area=20000)

        command = "convert \""+ fromFile + "\" -thumbnail "+area.to_s+"@ \""+ toFile+"\""
        if command
           puts command
           system(command)
        end
  end

end
