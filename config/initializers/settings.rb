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

MFILETYPE = Array.new(5)
MFILE_LOCATION = 1
MFILE_PHOTO = 2
MFILE_MOVIE = 3
MFILE_BOOK = 4
MFILE_UNDEFINED = 5

MFILETYPE[MFILE_LOCATION] = "Generic Link"
MFILETYPE[MFILE_PHOTO] = "Personal Photo"
MFILETYPE[MFILE_MOVIE] = "Movie"
MFILETYPE[MFILE_BOOK] = "Book"
MFILETYPE[MFILE_UNDEFINED] = "Undefined"

 
#STORAGES.each {|s| s.setpaths}
