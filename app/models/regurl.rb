class Regurl < ActiveRecord::Base
  
  def match(url)
    
    regex = %r{#{pattern}}

    result = regex.match(url)
     
    result || "no match"
  
  end
  
end
