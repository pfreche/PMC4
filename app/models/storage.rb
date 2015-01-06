class Storage < ActiveRecord::Base
  has_many :locations
  has_many :folders #  ":dependent => :destroy" too risky

  def webLocation
   locations.where(storage_id: id).where(inuse: true, typ: 1).first
  end
  
  def location(typ)
     locations.where(storage_id: id).where(inuse: true, typ: typ).first
  end
  
  def path(typ)
    if l = location(typ)
      l.uri      
    else
          ""
    end
  end
end
