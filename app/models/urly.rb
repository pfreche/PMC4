class Urly
 
   attr_accessor :url

   def initialize(u)
      @url = u
   end


   def loadURL
  
     Rails.cache.fetch(@url, expires_in: 12.hours) do
        begin
          open(@url).read
        rescue 
          "URL Load Error"
        end
     end
   end
   

end