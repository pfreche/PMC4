class UriHandler

  def self.part (path)
    return "a"
  end


  def parse(euri, filter)

  uri = URI.parse(euri)
  urlbase = euri

  a = UriHandler.part("aaaa")

  begin
    response = Net::HTTP.get_response(uri)
    page = Nokogiri::HTML(open(@location.uri))

    @title = page.css("title")[0].text
    links = page.css("a")
    @links = links.map {|l| URI.join(urlbase, l.attr("href").to_s).to_s}
    @links.select! { |l| l[%r{#{@filter}}] } if @filter

    links.each do |l|
      name = l.attr("href").to_s
      @title+=  "Href: " +name + " "
      url = URI.join(urlbase, name)
      @title+=  url.to_s + " <p>"
    end
  rescue StandardError
    #@title+= "site not available"
    #      doc = Nokogiri::HTML(open(@location.uri))
    #      @title = doc.css('title')
  end
    #   render :text => @title


  end

  end

