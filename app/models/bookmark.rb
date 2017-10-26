class Bookmark < ActiveRecord::Base
  belongs_to :folder  # connection to downloaded folder
  belongs_to :mfile   # connection to mfile from type bookmark to enable classifications

def folderTitle
   if folder
   	folder.title
   else
   	"not available"
   end
end

end
