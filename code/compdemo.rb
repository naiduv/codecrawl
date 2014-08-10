require 'net/http'
require 'json'

class Net::HTTPResponse
  def as_json
    JSON::parse(self.read_body)
  end
end

couch  = Net::HTTP.new("localhost",8888)
basura = Net::HTTP.new("localhost",8080)

puts "DELETE db"
puts couch.delete('/test_suite_db/')
puts basura.delete('/test_suite_db/')
puts
puts "PUT db"
puts couch.put('/test_suite_db/','')
puts basura.put('/test_suite_db/','')
puts
puts "GET db"
puts couch.get('/test_suite_db/')
puts basura.get('/test_suite_db/')
puts
puts "PUT db/0"
doc = {:_id => "0",:a => 1,:b => 1}
puts couch.put('/test_suite_db/0',doc.to_json)
puts basura.put('/test_suite_db/0',doc.to_json)
puts
puts "PUT db/4"
doc = {:_id => "4",:a => 4,:b => 16}
puts couch.put('/test_suite_db/4',doc.to_json)
puts basura.put('/test_suite_db/4',doc.to_json)
puts
puts "GET db/_all_docs"
puts couch.get('/test_suite_db/_all_docs')
puts basura.get('/test_suite_db/_all_docs')
puts
puts "POST db/_temp_view"
query = "(function (doc) {if (doc.a == 4) {return doc.b;}})"
puts couch.post('/test_suite_db/_temp_view', query)
puts basura.post('/test_suite_db/_temp_view', query)
puts
puts "GET db/0"
puts (c0 = couch.get('/test_suite_db/0'))
puts (b0 = basura.get('/test_suite_db/0'))
puts
puts "POST db"
doc = {:a => 3, :b => 9}
puts couch.post('/test_suite_db/',doc.to_json)
puts basura.post('/test_suite_db/',doc.to_json)
puts
puts "DELETE db/0?rev=n"
puts couch.delete("/test_suite_db/0?rev=#{c0.as_json['_rev']}")
puts basura.delete("/test_suite_db/0?rev=#{b0.as_json['_rev']}")
puts
puts "GET db/0"
puts couch.get('/test_suite_db/0')
puts basura.get('/test_suite_db/0')
puts
puts "DELETE db"
puts couch.delete('/test_suite_db/')
puts basura.delete('/test_suite_db/')
puts
puts "PUT db"
puts couch.put('/test_suite_db/','')
puts basura.put('/test_suite_db/','')
puts
docs = (0..4).map {|i| {:_id=>i.to_s, :integer=>i, :string=>i.to_s}}
puts "POST db _bulk_docs"
puts couch.post('/test_suite_db/',{:_bulk_docs=>docs}.to_json)
puts basura.post('/test_suite_db/',{:_bulk_docs=>docs}.to_json)
puts "POST db/_temp_view"
puts
puts "POST db/_temp_view"
query = "function(doc){return {key:doc.integer}}"
puts couch.post('/test_suite_db/_temp_view', query)
puts basura.post('/test_suite_db/_temp_view', query)
puts
puts "DELETE db"
puts couch.delete('/test_suite_db/')
puts basura.delete('/test_suite_db/')
puts
puts "PUT db"
puts couch.put('/test_suite_db/','')
puts basura.put('/test_suite_db/','')
puts
doc = {'text' => "Russian: \xd0\x9d\xd0\xb0 \xd0\xb1\xd0\xb5\xd1\x80\xd0\xb5\xd0\xb3\xd1\x83 \xd0\xbf\xd1\x83\xd1\x81\xd1\x82\xd1\x8b\xd0\xbd\xd0\xbd\xd1\x8b\xd1\x85 \xd0\xb2\xd0\xbe\xd0\xbb\xd0\xbd"}
puts doc.to_json.inspect
puts "PUT db russian"
puts couch.put('/test_suite_db/russian',doc.to_json)
puts basura.put('/test_suite_db/russian',doc.to_json)
puts
puts "GET db/russian"
puts couch.get('/test_suite_db/russian')
puts basura.get('/test_suite_db/russian')
puts
puts "POST db/_temp_view"
query = "(function (doc) {return doc.text;})"
puts couch.post('/test_suite_db/_temp_view', query)
puts basura.post('/test_suite_db/_temp_view', query)
puts
