treff, karo, coeur, pik, SA = 1,2,3,4,5

class Bid
  
  include Comparable

  def <=>(other)
    if self < other
      return -1
    end
    if self > other
      return +1
    end
    return 0
  end

  def succ
    Bid.new(@level, @suit) + 1 
  end

  def initialize(level, suit)
     @level = level
     @suit = suit
  end
  
  attr_accessor :level, :suit, :genuine
  
  def +(n)
  	levelUp = n / 5
  	steps = n % 5
  	
  	level = @level + levelUp
    suit = @suit + steps
    if suit > 5
      suit  = @suit - 5
      level = @level + 1
    end
    Bid.new(level,suit)
  end

  def <(bid)
    return  @level < bid.level || (@level = bid.level && @suit < bid.suit)
  end

  def >(bid)
      return  @level > bid.level || (@level = bid.level && @suit > bid.suit)
  end

  def ==(bid)

  end
end

class Fixnum 
	def treff
	  return Bid.new(self, treff)
	end
	def karo
	end
	def coeur
	end
	def pik
	end
	def SA
	end	
end

class Bidding
   @bids
   @uncontested

   def initialize 
   	
   end

   def complete?
   end

   def add (bid)
     if bid.is_instance_of(Bid)
      else
       bid = Bid.new(bid)
     end
     if isAllowed?(bid)
       @bids << bid
     else
    # exception     
     end

   end 
  
   def addP (bid)
      self.add "Passe"
      self.add bid
   end

   def << (bid)
   end
   
   def lastGenBid
   end

   def lastBid(step=1)
      @bids[-step]
   end


   def lastGenBid
     (1..4).each { |i|
       b = lastBid(i)
       return b if b.isGenuine
     }
   end

   def isAllowed?(bid)
     return false if complete?
     if bid.isGenuine
       return bid > lastGenBid      
     else
       return true if bid == "Passe"
       if bid == "X"
         return lastbid.isGenuine || lastbid(1) == "Passe" && lastbid(2) == "Passe" 
       end
       if bid == "XX"
         return lastbid == "X" || lastbid(1) == "Passe" && lastbid(2) == "X" 
       end
     end
   end

   def allowedBids
      
      @allowedBids = []
      if complete?
        return []
      end
      nextBid = lastGenBid + 1 
      (nextBid..7.SA).each {|b| @allowedBids << b }
   end

   def declarer
      @bids.each 
        if bid.suit == lastGenBid.suit 
   end

   def contract
     lastGenBid
   end
end

b = Bidding.new()

b << "passe" << 1.Coeur << 1.SA

