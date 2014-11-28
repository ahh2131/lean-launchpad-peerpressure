require "net/http"

namespace :request do
  desc "signup request"
  task signup: :environment do

uri = URI('http://dev.vigme.com:3000/api/signup')
req = Net::HTTP::Post.new(uri)
req.set_form_data('email' => 'andyvigmetet@aol.com', 'name' => 'just atest', 'password' => 'thisismypass')

res = Net::HTTP.start(uri.hostname, uri.port) do |http|
  http.request(req)
end

p res.value 
  end

end
