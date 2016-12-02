require "net/http"
require "uri"

# Token used to terminate the file in the post body. Make sure it is not
# present in the file you're uploading.
BOUNDARY = "AaB03x"

uri = URI.parse("http://192.168.178.65/Downloads/")
file = "jhead.exe"

post_body = []
post_body << "--#{BOUNDARY}\r\n"
post_body << "Content-Disposition: form-data; name='datafile'; filename='#{File.basename(file)}'\r\n"
post_body << "Content-Type: text/plain\r\n"
post_body << "\r\n"
post_body << File.read(file)
post_body << "\r\n--#{BOUNDARY}--\r\n"

http = Net::HTTP.new(uri.host, uri.port)
request = Net::HTTP::Post.new(uri.request_uri)
request.body = post_body.join
request.content_type = "multipart/form-data"

a = http.request(request)
puts a.body
