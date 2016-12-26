class Scantree

  @url 
  @parent
  @level
  @@scanners
  @ty

  attr_accessor :sts
  attr_accessor :level
  attr_accessor :ty
  attr_accessor :url
  
  def initialize (url,parent,level, ty, maxlevel) 
    @url = url
    @parent = parent
    @maxlevel = maxlevel
    @level = level
    @ty = ty
    @@scanners ||= Scanner.all
    @sts = []
  
  end

  
  def scan()

    if @level < @maxlevel
      
      @@scanners.each {|s|

        if s.matches?(@url) 
          
          ty = s.final ? s.final : ""
      
          thislinks = s.scan(@url).uniq
          if @parent
              links = @parent.check(thislinks) 
          else
            links = thislinks
          end
          links.each {|l| @sts << Scantree.new(l, self, @level+1, ty, @maxlevel)}
          if s.final == nil or s.final.strip == ""
            @sts.each {|l| l.scan}
          end
          
        end
      }
    end   
 end

  def checkr(links)
      @sts.each {|s|
        links.select! { |l| l != s.url  }
        links = s.checkr(links)
      }
      links
  end

  def check(links)
    if @parent
      @parent.check(links)
    else
      checkr(links)
    end
  end
 
  def show

   re = showl(self)


  end

   def showl(st)
     re = ""
     st.sts.each {|s|
      re+= "<div> "+s.level.to_s + " " + s.url + " " + s.ty + "</div>" 
      if s.sts
        re += showl(s)
      end
     }
     re
   end

  def to_a
   re = []
   re <<  [@url, @level,  @ty]
   re += asArray(self)

  end

   
   def asArray(st)
     re = []
     st.sts.each {|s|
      re << [s.url, s.level,  s.ty] 
      if s.sts
        re += asArray(s)
      end
     }
     re
   end

end
