
class Situation
  @sitcode
  @@code = 1

  def initialize(s)
    @sitcode = s
    @bid_classifiers = {}
  end
  def add_bid_classifier(bc,m,rs)
    @bid_classifiers[bc] = [m,rs]     
  end

  def bid(bc,m,rsitcode)
     rs = Situation.new(rsitcode)
     @bid_classifiers[bc] = [m,rs]     
  end
  
 # alias_method :abc, :add_bid_classifier

  def  bidNested(bc,m,&block)
  	@@code = @@code + 1
     rs = Situation.new(@@code)
    @bid_classifiers[bc] = [m,rs]     
    yield(rs)
  end	

  def match (b)
     rsit = nil
     @bid_classifiers.each {|bc,x| 
       if bc == b
          puts b + " m: "+ x[0]
          rsit = x[1] 
       end
     }
     puts b + " not defined" unless rsit
     return rsit

  end

end


class BSystem

  def initialize()
    @sits = {}
    @sits[:start] = Situation.new(:start)
  end

  def get_situation(sitcode)
    @sits[sitcode]
  end

def bid (sitcode,bc,m,rsitcode)
   
   rs = Situation.new(rsitcode)
   @sits[rsitcode] = rs

   situation = get_situation(sitcode)
   situation.add_bid_classifier(bc,m,rs)
end

def bi (sitcode,&block)
   situation = get_situation(sitcode)
   yield(situation)
end

def b (bc,m,rsitcode)
end

def bidding(*x)
  
  sit = @sits[:start]

  x.each  {|y| 
    sit = sit.match(y) 
  } 
end

def show_sits
	@sits.each {|s| puts s}
end


end

bs = BSystem.new

bs.bid(:start, "1T", "16+", :n1t)
bs.bid(:start, "1K", "11-16", :n1k)

bs.bi(:start){ |sit|
	 sit.bid "1SA", "bal. 11-13", :n1SA
	 sit.bid "1C", "5er 11-15", :n1OF
	 sit.bid "1P", "5er 11-15", :n1OF
}

bs.bid(:n1t, "1K", "0-8", :n1t1k)
bs.bid(:n1t, "1C", "8+, 5er", :n1t1M)

bs.bi(:n1t){ |sit|
	 sit.bid "2T", "5er ab 8", :n1t1SA
	 sit.bid "2SA", "bal. 14+", :n1t2SA
	 sit.bidNested("1SA","bal. 8-13"){ |sit|
        sit.bid "2T", "Frage", :TranferStayman
	    sit.bid "2K", "5er", :x
		 }
}

bs.bi(:TranferStayman)

bs.bidding("1T","2SA")
bs.bidding("1T","1SA","2T")

