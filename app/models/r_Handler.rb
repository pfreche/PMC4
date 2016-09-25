class RHandler

def self.extract(url, tag, pattern)
    
    sourcee = loadURL(url)
    page = Nokogiri::HTML(sourcee)

    urlbase = url
    
    links = page.css("a")
    links = links.map { |l| 
      begin
      URI.decode(URI.join(urlbase, (l.attr("href")||"").to_s).to_s)
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

def self.loadURL(u)
  
    Rails.cache.fetch(u, expires_in: 12.hours) do
          open(u).read
    end
 end

end