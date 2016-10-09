class Scanner < ApplicationRecord

  attr_accessor :urlExtern

  def matches?(url)

    regex = %r{#{match}}

    result = regex.match(url)

    result 

  end

  def matchS(url)
     if matches?(url)
     	" FIT "
     else 
     	" --- "
     end
  end

end
