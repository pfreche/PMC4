class Container
 
 @@counter = 0
 @@collection = {}
 @@dl_files = {}
 @@thread = "init"
 
 def self.thread()
  @@thread.status
 end

 def  self.inc()
  @@counter = @@counter +1
  end

  def self.counter()
    @@counter
  end 
 
  def self.del_queue()
    @@collection = {}
  end 

  def self.add(env)

      request = Rack::Request.new(env)
#      @@collection[env["QUERY_STRING"]] = "x"
       @@collection[CGI.unescape(request.params['web'])] = [CGI.unescape(request.params['file']), CGI.unescape(request.params['referer'])]
  end

  def self.start_bdl()

     if @@thread == "init" or @@thread.status == nil or @@thread.status == false
      @@thread = Thread.new{Container.dl_queue()}
       return "download started"
    else
       return "download not started already running"
    end
  end

  def self.dl_queue()
    n = 0
    @@dl_files = @@collection.dup

    @@collection = {}

    @@dl_files.each do |web,q|
#       referer = nil
       file = q[0]
       referer = q[1]
       uri = URI.parse(URI.encode(web))
       next unless uri 
          if referer == nil
             referer = uri.scheme + "://"+uri.host
           end
        @curl = "curl -e \"" + referer +  "\""
        @curl =  @curl + " -o \""+ file + "\" \"" + web +  "\""
        p @curl
#        Process.spawn(@curl)
        system(@curl)
        n = n + 1 
    end
     @@dl_files = {}
    return n 
  end

  def self.collection
     @@collection 
  end

end

run Proc.new { |env| 
	Container.inc()
#  path = env["PATH_INFO"]
  request = Rack::Request.new(env)
  rpath = env['REQUEST_PATH']
  
  if request.params['web']
    Container.add(env)

#   ['200', {'Content-Type' => 'text/html'}, [env["PATH_INFO"].to_s]] 
    ['200', {'Content-Type' => 'text/html'}, [Container.collection.to_s]] 
  else
    case rpath
    when '/bdl'
        r = Container.start_bdl()
       ['200', {'Content-Type' => 'text/html'}, [r]]    
    when '/dl'
        n = Container.dl_queue()
       ['200', {'Content-Type' => 'text/html'}, [n.to_s+ ' files downloaded']]    
    when '/queue'
       ['200', {'Content-Type' => 'text/html'}, [Container.collection.to_s]]
    when '/delqueue'
        Container.del_queue()
       ['200', {'Content-Type' => 'text/html'}, [Container.collection.to_s]]
    when '/status'
#        @@thread = "empty" unless @@thread
       ['200', {'Content-Type' => 'text/html'}, [Container.thread().to_s]]
    else
       ['200', {'Content-Type' => 'text/html'}, [env.to_s]] 
    end
  end
}
