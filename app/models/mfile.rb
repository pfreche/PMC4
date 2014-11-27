class Mfile < ActiveRecord::Base
  has_and_belongs_to_many :attris
  has_and_belongs_to_many :agroups
  belongs_to :folder
  def path(typ)
    if typ == URLWEBTN # Web TN
      folder.path(typ) +"/"+id.to_s+".jpg"
    else
      folder.path(typ) +"/"+filename
    end
  end
end
