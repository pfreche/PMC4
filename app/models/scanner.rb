class Scanner < ApplicationRecord

  attr_accessor :urlExtern
  attr_accessor :lastMatch 

  @@cache = true

  def matches?(url)

    regex = %r{#{match}}
    result = regex.match(url)
    @lastMatch = result
    result 

  end

  def matchS(url)
     if matches?(url)
     	" FIT "
     else 
     	" --- "
     end
  end

  def scan(url)

#def self.extract(url, tag, attr, pattern)
    
    sourcee = Scanner.loadURL(url)
    if sourcee == "URL Load Error"
        links = ["Error"]
    end

    if tag.strip == ""
      links = []
      links[0] = sourcee
    else 
    page = Nokogiri::HTML(sourcee)

    urlbase = url
    
    links = page.css(tag)
    i = 0
    links = links.map { |l| 
      begin
      if attr and attr.length >0 
        URI.decode(URI.join(urlbase, (l.attr(attr)||"").to_s).to_s)
      else 
        i = i  + 1
        l.text.to_s
      end
      rescue
        "failure"
      end
      } 
    
    end

    pa = pattern
    pattern = pa.sub("<url>",url)
    
    links.select! { |l| l[%r{#{pattern}}] } if pattern
    if pattern and pattern.length >0 
        links.map! { |link| 
          %r{#{pattern}}.match(link)[1]
        } 
    end

  links
 
  end

  def self.matchAndScan(url, level = 0, maxdepth=3, scanners=nil, result={})

    maxdepth = maxdepth - 1
    return {} if maxdepth < 0
    scanners ||= Scanner.all
    scanners.each {|s|
       if s.matches?(url)
          if s.stype  and s.stype != ""
            result[url] = [level,s.stype]
          end
            thislinks = s.scan(url).uniq # uniq added 20171014
            thislinks.each {|l|
               unless result[l]          # if link is not already found 
                  result[l] = [level, s.final]
                  unless s.final == "x" or s.final == "Error"
                     u =  Scanner.matchAndScan(l, level + 1, maxdepth, scanners, result)
                  end
      	       end
       	    }
#          else
#		jlj
#	  end 
       end
    } 
    result 
 end

  def self.matchAndScanBak(url, level = 0, maxdepth=3, scanners=nil)
    maxdepth = maxdepth - 1
    return [] if maxdepth < 0

    scanners ||= Scanner.all
    links = []
    scanners.each {|s|

        if s.matches?(url) 
          
          thislinks = s.scan(url).uniq # uniq added 20171014
          thislinks.map! {|l| [l, level, s.final]}
          unless s.final == "x" or s.final == "Error"
            nextlinks = []
            thislinks.each {|l|
              nextlinks << l
              nextlinks += matchAndScan(l[0], level + 1, maxdepth, scanners)
            } 
            thislinks = nextlinks if nextlinks.length > 0 
          end
          links += thislinks
        end
    } 
    links
  end


def self.createFolder(foldername, folderTitle,location)
    

    f = Folder.where(storage_id: location.storage.id, mpath: foldername, lfolder: "")
    if !f.empty?
       folder= f.first
    else
      folder = Folder.new
      folder.mpath = foldername
      folder.lfolder = ""
      folder.title = folderTitle
      folder.storage_id = location.storage_id
      folder.save
    end 
    location.mkDirectories(folder)
    return folder

end

def self.createFolderAndMfiles(url,links,location)

    linksToSave =  links.select{|url,l| l[1]=="x"    }.map{|url,l| url.rstrip}
    folderTitles = links.select{|url,l| l[1]=="title"}.map{|url,l| url.rstrip}
    if folderTitles.length > 0
      folderTitle = folderTitles[0]
    else 
      folderTitle = ""
    end  

    @commonStart = Scanner.detCommonStart(links)
    locationLength = location.uri.length
    ldiff = - @commonStart.length + locationLength 
    if ldiff < 0 
       foldername = @commonStart[ldiff..-1]   
    else
       foldername = ""
    end 
    folder = Folder.new
    
    folder.mpath = foldername
    folder.lfolder = ""
    folder.title = folderTitle

    folder.storage_id = location.storage_id
    folder.save

    offsetLength = foldername.length + locationLength

    linksToSave.each {|l|

      mfile = Mfile.new
      mfile.folder_id = folder.id
      ldiff = offsetLength - l.length
      mfile.filename = l[ldiff..-1]
      mfile.mtype = MFILE_IMEDIUM # 20171015
      mfile.save
    }

   folder
end


def self.createFolderAndMfilesBak(url,links,location)

    linksToSave =  links.select{|l| l[2]=="x"}.map{|l| l[0].rstrip}.uniq
    folderTitles =  links.select{|l| l[2]=="title"}.map{|l| l[0].rstrip}.uniq
    if folderTitles.length > 0
      folderTitle = folderTitles[0]
    else 
      folderTitle = ""
    end  

    @commonStart = Scanner.detCommonStart(links)
    locationLength = location.uri.length
    ldiff = - @commonStart.length + locationLength 
    if ldiff < 0 
       foldername = @commonStart[ldiff..-1]   
    else
       foldername = ""
    end 

    folder = Folder.new
    
    folder.mpath = foldername
    folder.lfolder = ""
    folder.title = folderTitle

    folder.storage_id = location.storage_id
    folder.save

    offsetLength = foldername.length + locationLength

    linksToSave.each {|l|

      mfile = Mfile.new
      mfile.folder_id = folder.id
      ldiff = offsetLength - l.length
      mfile.filename = l[ldiff..-1]
      mfile.mtype = 2 ########### muss noch im Dialog abgefragt werden
      mfile.save
    }
#   new Folder

#  mfile.folder

   folder
end



def self.detCommonStartNew(st)

  st.sts.each {|s|
  }

end

def self.detCommonStart(links)

   cs = nil
   x = 0
   links.each {|link, value| 
      next unless value[1] == "x" # take only finals
      l = link.strip          # the url
      x = x + 1
      if !cs
        cs = l
      else
        len = l.length
        len = cs.length if len>cs.length
        j = -1
        (0...len).each { |i|
          break if cs[i] != l[i]
          j = j + 1
        }
        cs = l[0..j]
      end
   }

   return "" unless cs
  /(.*\/)/.match(cs)[1].strip
end

def self.detCommonStartBak(links)

   cs = nil
   x = 0
   links.each {|link| 
      next unless link[2] == "x" # take only finals
      l = link[0].strip          # the url
      x = x +1
 #     break if x >211
      if !cs
        cs = l
      else
        len = l.length
        len = cs.length if len>cs.length
        j = -1
        (0...len).each { |i|
          break if cs[i] != l[i]
          j = j + 1
        }
        cs = l[0..j]
      end
   }

   return "" unless cs
  /(.*\/)/.match(cs)[1].strip
end


def self.loadURL(u)
 
 if u == "clear"
    @@cache = false
 end
 if u == "cache"
    @@cache = true
 end

# if true
#    Rails.cache.delete(u)
# end

    Rails.cache.fetch(u, expires_in: 12.hours) do
        begin
         open(u).read  #1
 
#1          uri = URI.parse(u)
          
#	  pams = { :id => 97563, :page => 3 }
#          uri.query = URI.encode_www_form(pams)

#1          req = Net::HTTP::Get.new(uri.request_uri)
#1          req['Referer'] = uri.scheme+"://"+uri.host
#1          Net::HTTP.start(uri.host, uri.port) do |http|
#1              response = http.request(req)
#1              response.body 
#1         end

#       rescue 
#          "URL Load Error"
        end
    end
 end


end
