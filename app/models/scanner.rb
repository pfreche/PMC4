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
    page = Nokogiri::HTML(sourcee)

    urlbase = url
    
    links = page.css(tag)

    links = links.map { |l| 
      begin
      if attr and attr.length >0 
        URI.decode(URI.join(urlbase, (l.attr(attr)||"").to_s).to_s)
      else 
        l.text.to_s
      end
      rescue
        "failure"
      end
      } 
#    eeej
    
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

  def self.matchAndScan(url, level = 0, maxdepth=3, scanners=nil)
    maxdepth = maxdepth - 1
    return [] if maxdepth < 0

    scanners ||= Scanner.all
    links = []
    scanners.each {|s|

        if s.matches?(url) 
          
          thislinks = s.scan(url) 
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



def self.createFolderAndMfiles(url,links,location)

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

 if true
#    Rails.cache.delete(u)
 end

    Rails.cache.fetch(u, expires_in: 12.hours) do
        begin
          open(u).read
        rescue 
          "URL Load Error"
        end
    end
 end


end
