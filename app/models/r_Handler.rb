class RHandler

def self.extract(url, tag, attr, pattern)
    
    sourcee = loadURL(url)
    page = Nokogiri::HTML(sourcee)

    urlbase = url
    
    links = page.css(tag)

    links = links.map { |l| 
      begin
      if attr and attr.length >0 
        URI.decode(URI.join(urlbase, (l.attr(attr)||"").to_s).to_s)
      else 
        l.to_s
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

def self.loadURL(u)
  
    Rails.cache.fetch(u, expires_in: 12.hours) do
          open(u).read
    end
 end

end