class UriHandler

  def self.part (path)
    return "a"
  end

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

end