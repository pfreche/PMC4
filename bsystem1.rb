
class BSystem

def tart(bc, &block)

 	define_singleton_method ("a") do
     ee= 1
    puts "a called"
    end
   yield
end

def self.s(h)

 	define_singleton_method(h) do |bc, &b|
      puts bc
      b.call
      define_method("_"+h) do |bce|
        puts bce
        b.call
      end


    end


end

def self.m(text)
  puts text
end

def start(bc)
	aee =1
end

#def self.start(bc, &block)

#    yield
# 	define_singleton_method (@sss) do |bc, &b|
#      puts bc
#      b.call
#    end
 
#end

# beginn system
 
 s "start"


 start("1T") {
    m "16+"
    s "n1T"
 }

  n1T("2T"){ s "n2T"; m "8+, 5er" }
  n2T("2P"){ s "n2T"; m "5er" }

# end system
end



def s(x)
   puts x
end


#BSystem.start("lllllllllllllllllllllllllllll") {puts "lllllaaaaaaaaaaaaaaaaaa"}
x = BSystem.new
x.tart("1T"){puts "tart"; s "lllll"}

x._start("1T")
x._n1T("2T")

# Bsytem.bidding(x)


class Situation
  def next(a,&b)
  end
end

def sit(s)
	po = Situation.new
end

start = Situation.new
start.next("1P"){sit "1p"  }



