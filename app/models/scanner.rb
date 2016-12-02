class Scanner < ApplicationRecord

  attr_accessor :urlExtern
  attr_accessor :lastMatch 

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
#    Rails.cache.delete(u)
    Rails.cache.fetch(u, expires_in: 12.hours) do
        begin
          open(u).read
        rescue 
          "URL Load Error"
        end
    end
 end


end
