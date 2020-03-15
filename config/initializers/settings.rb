module Business
  class Logic
    @@dl_method = 0
    Here = "hello world"
    def self.dlm=(y) #blödsinn
      x = y.to_i
      if x.is_a? Integer
        @@dl_method = x
      end
    end
    def self.dlm()
      @@dl_method
    end
  end
end

module Config
  class Settings
    @@dl_method = 2 # 0 intern, 1 curl, 2 extern 
    def self.dlm=(x)
      @@dl_method = x.to_i
    end
    def self.dlm()
      @@dl_method
    end
  end
end

kala = "dies ist eine Variable"
@kala = "dies ist eine @-Variable"
#KALA = Folder.find(1)
STORAGES = Storage.all
FOLDERPATH = Array.new(100,nil)
URLWEB = 1 # Web URL
URLWEBTN = 3 # Web URL for Thumbnails
#URLFS = 2 # ...
FILEPATH = 55 # Filepath
FILETNPATH = 56


URL_WEB = 0
URL_STORAGE_WEB = 1
URL_STORAGE_WEBTN = 3
URL_STORAGE_FS = 2
URL_STORAGE_FSTN = 4

TYPPP = Array.new(5)
TYPPP[URL_WEB ] = "Generic Web Access URL"
TYPPP[URL_STORAGE_WEBTN] = "Storage: Web TN"
TYPPP[URL_STORAGE_WEB ] = "Storage: Web"
TYPPP[URL_STORAGE_FSTN] = "Storage: Filesystem TN"
TYPPP[URL_STORAGE_FS] = "Storage: Filesystem"

MFILETYPE = Array.new(8)
MFILE_UNDEFINED = 0
MFILE_LOCATION = 1
MFILE_PHOTO = 2
MFILE_MOVIE = 3
MFILE_BOOK = 4
MFILE_IMEDIUM = 5
MFILE_BOOKMARK = 6
MFILE_YOUTUBE = 7

MFILETYPE[MFILE_UNDEFINED] = "Undefined"
MFILETYPE[MFILE_LOCATION] = "Generic Link"
MFILETYPE[MFILE_PHOTO] = "Personal Photo or Film"
MFILETYPE[MFILE_MOVIE] = "Movie"
MFILETYPE[MFILE_BOOK] = "Book"
MFILETYPE[MFILE_IMEDIUM] = "Medium from Internet"
MFILETYPE[MFILE_BOOKMARK] = "Bookmark"
MFILETYPE[MFILE_YOUTUBE] = "Youtube Video"


#STORAGES.each {|s| s.setpaths}
