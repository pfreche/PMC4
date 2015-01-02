class Location < ActiveRecord::Base
  belongs_to :storage
  belongs_to :mfile
end
