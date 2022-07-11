require 'net/http'
require 'uri'
require 'json'



# get access_token
# (https GET with basic auth)
uri = URI('http://192.168.200.5/api/v2/inventories/2/hosts/')
req = Net::HTTP::Get.new(uri)
req.basic_auth('root', 'shosys')
res = Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') { |http|
  http.request(req)
}
if res.is_a?(Net::HTTPSuccess)
  access_token = JSON.parse(res.body)['access_token']
else
  abort "get access_token failed: body=" + res.body
end

#puts JSON.pretty_generate(JSON.parse(res.body))

post_body_hash = { 
  name: "test.host",
  description: "test"
} 
post_body_json = JSON.pretty_generate(post_body_hash)
uri = URI('http://192.168.200.5/api/v2/inventories/2/hosts/')
req = Net::HTTP::Post.new(uri)
req.basic_auth('root', 'shosys')
req['Content-Type'] = req['Accept'] = 'application/json'
req.body = post_body_json
res = Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') { |http|
  http.request(req)
}

puts res.body
