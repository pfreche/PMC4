class UriHandler

  def self.part (path)
    return "a"
  end

  def self.getFiles(path, filter)
    links =[]
    Dir.glob(path+"/**/*") {|f| links << f unless File.directory?(f)}
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
    
#   links.select! { |l| l[%r{#{filter}}] } if filter

#   links = links.map {|l| [l, URI(l).path, l[%r{#{filter}}] ]}

  rescue StandardError

  end
  
   links
  end

def self.match(links,setlocation=nil)
   
   matchList = Array.new
   
   locuri = location.uri if setlocation
      
   links.each do |link| 
     loc, path = nil
          
     if setlocation
       if link.first(locuri.length) == locuri
         loc = setlocation
       end
     else
       puts link
       ls = link.split(/\//)
       blink = ""
       ls.each do |l| 
         blink = blink + l +  "\/" 
         location = Location.where(uri: blink).first  # kann man besser machen, locations lokal mit speichern
         if location && location.storage_id
           loc = location
         end
       end
     end
     
     if loc
       length = link.length
       ulength = loc.uri.length
       path = link.last(length-ulength)
     end
     

      matchList << ([link,loc,path]+ canonize(path))
      
   end
   
   matchList
end

def self.canonize(cpath)
  
     cpath = "" unless cpath
     split = cpath.split(/\//).reverse
     name = split[0] || ""
     lfolder = split[1] || "" 
     
     path = ""
     le = split.length - 1
     if le > 1
       (le..2).each do |i|
         path += split[i] || ""
       end
    end
    [path,lfolder,name]

end


def self.save(matchedLinks)
  
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
      mfile.mtype = 99   
      
      mfile.save  
     
    end       
 end  
 end

end