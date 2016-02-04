class Match < ActiveRecord::Base
  
  def match(url)

    regex = %r{#{pattern}}

    result = regex.match(url)

    result || false

  end
end
