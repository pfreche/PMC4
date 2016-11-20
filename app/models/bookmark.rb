class Bookmark < ActiveRecord::Base
  belongs_to :folder

def folderTitle
   if folder
   	folder.title
   else
   	"not available"
   end
end

end
