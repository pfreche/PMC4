class UriHandler

  def self.getFiles(path, filter)
    links = []
    if filter == nil
      filter  = "."
    end
    Dir.glob(path+"/**/*") {|f| 
      if !File.directory?(f) and f[%r{#{filter}}] 
        links << f 
      end
      }
    links
  end

  def self.getLowestDirs(path, filter)
    links = []
    Dir.glob(path+"/**/*") {|f| links << f if File.directory?(f)}
    
    #unfertig
    
    links
  end



  def self.getLinks(euri, filter)

  uri = URI.parse(euri)
  urlbase = euri

  begin
    response = Net::HTTP.get_response(uri)
    page = Nokogiri::HTML(open(urlbase))

#    @title = page.css("title")[0].text
    links = page.css("a")
    links = links.map {       |l| 
      begin
      URI.join(urlbase, (l.attr("href")||"").to_s).to_s
      rescue
        "failure"
      end
      }
    images = page.css("img")
    images = images.map {|i| URI.join(urlbase, i.attr("src").to_s).to_s}
    links += images
    
   links.select! { |l| l[%r{#{filter}}] } if filter

#   links = links.map {|l| [l, URI(l).path, l[%r{#{filter}}] ]}

  rescue StandardError

  end
  
   links
  end

def self.match(links,setlocation=nil)
   
   matchList = Array.new
   
   locuri = setlocation.uri if setlocation
   
   collectedLocations = []
   
   allLocations = Location.where(typ: URL_STORAGE_WEB) + Location.where(typ: URL_STORAGE_FS)
      
   links.each do |link| 
     locuri, path = nil
          
     if setlocation
       if link.first(locuri.length) == locuri
         loc = setlocation
       end
     else
       http = %r/httup:\/\//
       if link =~ http
         link = link.last(link.length-7)
         ls = ["http://"]+link.split(/\//)
       else
         ls = link.split(/\//)
       end

       
       blink = ""
       if collectedLocations
         ls.each do |l| 
           blink = blink + l 
         
#          if c = collectedLocations.detect {|l| l==blink}
#             locuri = c
#           end
           if c = allLocations.detect {|l| l.uri==blink}
             locuri = c
           end 
           blink = blink + "\/" 
         end
       end
       
#       unless locuri
#         blink = ""
#         ls.each do |l| 
#           blink = blink + l +  "\/" 
#
#           location = Location.where(uri: blink).first  
#           if location && location.storage_id
#             locuri = blink
#           end
#         end
#         if locuri
#             collectedLocations << locuri
#         end      
#      end
       
       if locuri
         length = link.length
         ulength = locuri.uri.length
         path = link.last(length-ulength)
       end
     
       matchList << ([link,locuri,path]+ canonize(path))
     end
   end
   
   matchList
end

def self.canonize(cpath)
  
     cpath = "" unless cpath
     split = cpath.split(/\//).reverse
     name = split[0] || ""
     lfolder = split[1] || "" 
     
     split.reverse!
     
     path = ""
     le = split.length - 3
     if le > -1
       (0..le).each do |i|
         path += split[i] + "/"
       end
    end
    [path,lfolder,name]

end


def self.save(matchedLinks, mtype)
  
  
  matchedLinks.each do |a|
    
    next unless a[1]
    
    foldernew = false
    location = a[1]
    folder = Folder.where(storage_id: location.storage_id, mpath: a[3], lfolder: a[4]).first
    
    unless folder
      folder = Folder.new
      folder.storage_id = location.storage_id
      folder.mpath = a[3]
      folder.lfolder = a[4]
      folder.save
      
      foldernew = true
  
    end
   
    if foldernew or !Mfile.where(folder_id: folder.id, filename: a[5]).first
      mfile = Mfile.new
      mfile.filename = a[5]
      mfile.folder_id = folder.id
      mfile.mtype = mtype   
      
      mfile.save  
     
    end       
 end 
 Folder.resetFOLDERPATH
 end
 
 def self.mkDirectories(toLocation)

   storage = toLocation.storage
   uri = toLocation.uri
# check types
   
   return "wrong typ in toLocation"    unless toLocation.typ == URL_STORAGE_FS  or toLocation.typ == URL_STORAGE_FSTN
   
# get all folder from storage

   folders = storage.folders
   
   folders.each do |folder|
     f = uri + "/"+ folder.mpath + "/" + folder.lfolder
     
     fsplit = f.split(/\//)
     fr = ""
     fsplit.each do |fs|
       next if fs == ""
       fr = File.join(fr,fs)
       Dir.mkdir(fr) unless File.exist?(fr) 
         
       puts fr
     end
   end
 
 end
 
 def self.copyFiles(fromLocation, toLocation)
   
   storage = toLocation.storage
   return "different storages" unless fromLocation.storage == storage
   toUri = toLocation.uri
   fromUri = fromLocation.uri
# check types
   return "wrong typ in fromLocation"  unless fromLocation.typ == URL_STORAGE_FS  or fromLocation.typ == URL_STORAGE_FSTN
   return "wrong typ in toLocation"    unless toLocation.typ == URL_STORAGE_FS  or toLocation.typ == URL_STORAGE_FSTN
   
# get all folder from storage - fromLocation

   folders = storage.folders
   
   folders.each do |folder|
     from = File.join(fromUri, folder.mpath, folder.lfolder)
     to =   File.join(toUri, folder.mpath, folder.lfolder)
     
     mfiles = folder.mfiles
     
     mfiles.each do |mfile|           
        FileUtils.cp(File.join(from,mfile.filename), File.join(to,mfile.filename))      
     end
   end
 end

 def self.generateTNs(fromLocation, toLocation, prefix="tn_")
   
   storage = toLocation.storage
   return "different storages" unless fromLocation.storage == storage
   toUri = toLocation.uri
   fromUri = fromLocation.uri
# check types
   return "wrong typ in fromLocation"  unless fromLocation.typ == URL_STORAGE_FS  
   return "wrong typ in toLocation"    unless toLocation.typ == URL_STORAGE_FSTN
   
# get all folder from storage - fromLocation

   folders = storage.folders
   
   folders.each do |folder|
     from = File.join(fromUri, folder.mpath, folder.lfolder)
     to =   File.join(toUri, folder.mpath, folder.lfolder)
     
     mfiles = folder.mfiles
     
     mfiles.each do |mfile|           
        command = "jhead -st " + File.join(to,prefix+mfile.filename) + " " + File.join(from,mfile.filename)
         puts command
        system(command)
     end
   end
 end

# check the Content
 def self.checkContent(location)
   
   storage = location.storage
   typ = location.typ
   
   folders = storage.folders
   
   n = 0
   avail = 0
   
   folders.each do |folder|
     
     mfiles = folder.mfiles
     
     mfiles.each do |mfile|
       n = n + 1
       path = File.join(location.uri, folder.mpath, folder.lfolder, mfile.filename)
       puts path    
       if typ == URL_STORAGE_FS  or typ == URL_STORAGE_FSTN
           avail = avail + 1 if File.exist?(path)
       end       
       if typ == URL_WEB  or typ == URL_STORAGE_WEB or typ == URL_STORAGE_WEBTN
         
 #          begin 
 #             open( path, :method => :head).status
 #             avail = avail + 1
 #             rescue StandardError
 #          end
             
#          begin
#              response = Net::HTTP.get_response(URI.parse(path))
#              puts response.value
#              if response.kind_of? Net::HTTPSuccess
#                 avail = avail + 1
#              end
#           rescue StandardError
#           end

          begin
              uri = URI.parse(path)
              response = nil
              Net::HTTP.start(uri.host, uri.port) do |http|
                 response = http.head(uri.path)
              end
              puts response.code.to_i
              if response.kind_of? Net::HTTPSuccess
                 avail = avail + 1
              end
           rescue StandardError
             puts "error"
           end

       end 
     end
   end   
   [n,avail]
 end

 def self.checkAvail(location)
   
     ltyp = location.typ
     
     if ltyp == URL_WEB  or ltyp == URL_STORAGE_WEB or ltyp == URL_STORAGE_WEBTN
           
           @title = "Site is not available"
           begin
              response = Net::HTTP.get_response(URI.parse(location.uri))
              puts response.value
              if response.kind_of? Net::HTTPSuccess
                 @title = "Site is available"
              end
           rescue StandardError
           end    
     end
     
     if ltyp == URL_STORAGE_FS or ltyp == URL_STORAGE_FSTN 
     
       if File.exist?(location.uri)
          @title = "Directory is there"
       else
          @title = "Directory does not exist"
       end
     end
     
     @title
   
 end



end