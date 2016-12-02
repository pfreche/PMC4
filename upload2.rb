require 'net/http/post/multipart'


url = URI.parse('http://192.168.178.65/Downloads/')
req = Net::HTTP::Post::Multipart.new url.path, "file1" => UploadIO.new(File.new("./image.jpg"), "image/jpeg", "image.jpg")

res = Net::HTTP.start(url.host, url.port) do |http|
  http.request(req)
end

uri = URI('http://192.168.178.65/Downloads/?mode=section&id=ajax.mkdir')
res = Net::HTTP.post_form(uri, 'name' => 'newFolderi')
puts res.body


#require 'net/http'
response = nil
Net::HTTP.start('192.168.178.65', 80) {|http|
  response = http.head('/Downloads/')
}
puts response.code