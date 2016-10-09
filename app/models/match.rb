# obsolete !!! to be deleted
class Match < ActiveRecord::Base
  
  def match(url)

    regex = %r{#{pattern}}

    result = regex.match(url)

    result || false

  end

  def matchS (url)
     if match(url)
     	"fits"
     else 
     	"nofit"
     end
  end
end
