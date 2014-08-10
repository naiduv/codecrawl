require 'open-uri'
require 'md5'
require 'rexml/document'
require 'cgi'
require 'yaml'
include REXML

# Extremely Dirty Hack to deal with certificate errors. This is fixed in ruby1.9
# Use this as a last resort to fix the errors. You are essentially bypassing the SSL security validation because of this.
# Uncomment the following two lines
#require 'net/https'
#OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

def parseResponse(rsp, debug=false)
	results={}
	doc=Document.new(rsp)
	doc.elements.each('/descendant::response') do |e|
		e.elements.each do |c|
			case c.name
			when 'meta'
				meta={}
				puts "Found Meta section" if debug
				c.elements.each do |d| 
					puts "\t#{d.name} => #{d.text}" if debug
					meta[d.name] = d.text
				end
				results[:meta]=meta

			when 'results'
				res={}
				puts "Found Results section" if debug
				c.elements.each do |d| 
						puts "\t#{d.name} => #{d.text}" if debug
						if d.name =~ /^url[\d]+/
								puts "URL Encountered!" if debug
								url={}
								res[:urls] ||= []
								d.elements.each do |u|
									puts "\t\t#{u.name} => #{u.text}" if debug
									url[u.name]=u.text
								end
								res[:urls] <<url
						else
							res[d.name]=d.text
						end
				end
				results[:results]=res
			end
		end
	end
	results
end

class PhishTank
	@@BASEURL ='https://api.phishtank.com:443'
	@@API_VERSION=1
	@@RESP_FORMAT='xml'
	@@LOG_RESP = false
	attr_reader :frob

	def initialize(app_key,shared_secret,frob=nil)
		@app_key=app_key
		@shared_secret=shared_secret
		@frob=frob
		@request_format = "/api/?version=#{@@API_VERSION}&responseformat=#{@@RESP_FORMAT}&app_key=#{@app_key}&"
	end

	def create_request_parse_response(extras, debug=false)
		# shamelessly copied form action_controller/routing.rb 
		elements = []
		extras.keys.each do |key|
			value = extras[key] or next
			key = key.to_s
			elements << "#{key}=#{value.to_s}"
		end
		
		request_format = @request_format+elements.join("&")
		sig = generate_signature(request_format, debug)
		request_format+="&sig=#{sig}"
		u=URI(@@BASEURL+request_format)
		puts "Trying [#{u.to_s}]" if debug
		rsp=u.read
		if(@@LOG_RESP)
			File.open("logs/"+extras[:action],"wb") do |f|
				f.puts rsp
			end
		end
		results = parseResponse(rsp)
	end

	def generate_signature(request_string, debug=false)
		puts "GS: Req Str = #{request_string}" if debug
		tmp=request_string.split('?').pop
		sig=""
		params=tmp.split('&').sort
		puts "GS: params = #{params.join " "}" if debug
		params.each{|q| sig+= q.sub(/=/,'')}
		puts "GS: sig = #{sig}" if debug
		sig=@shared_secret+sig
		puts "GS: sig = #{sig}" if debug
		sig=MD5.hexdigest(sig)
		puts "GS: hexdigest sig = #{sig}" if debug
		sig
	end

	def ping()
		extras={:action=>"misc.ping"}
		result=create_request_parse_response(extras)
		puts "Error:  #{result[:results]["errortext"]}" if result[:results]["errortext"]
		return (result[:results]["pong"])
	end

	def update_frob(callback_url=nil)
		extras={:action=>"auth.frob.request"}
                extras[:callback_url]=callback_url if callback_url
		doc=create_request_parse_response(extras)
		puts "Error: ", doc[:results]["errortext"] if doc[:results]["errortext"]
		@frob = doc[:results]["frob"]
		auth_url = doc[:results]["authorization_url"]
	end

	def get_frob_status()
		extras = {:action=>"auth.frob.status", :frob=>@frob}
		results=create_request_parse_response(extras)
		if results[:results]["errortext"]
                    print "Error: ", results[:results]["errortext"], "\n" 
                    return false
                end
		frob_status = results[:results]["status"] || nil 
		puts "FROB Status = #{frob_status}" if frob_status
		@username = results[:results]["username"] if results[:results]["username"]
		puts "Username = #{@username}"
		@apikey = results[:results]["apikey"] if results[:results]["apikey"]
		puts "API Key = #{@apikey}"
                return true
	end

	def get_token()
		extras = {:action=>"auth.token.request", :api_key=>@apikey,
			:username=>@username}
		doc=create_request_parse_response(extras)
		puts "Error: ", doc[:results]["errortext"] if doc[:results]["errortext"]
		@token = doc[:results]["token"] if doc[:results]["token"]
		puts "Token = #{@token}"
	end

	def check_token()
		extras = {:action=>"auth.token.status", :api_key=>@apikey,
			:username=>@username,:token=>@token}
		doc=create_request_parse_response(extras)
		puts "Error: ", doc[:results]["errortext"] if doc[:results]["errortext"]
		vs = doc[:results]["valid"] if doc[:results]["valid"]
		ss = doc[:results]["secondsleft"] if doc[:results]["secondsleft"] 
		puts "Token Valid = #{vs}, for #{ss} seconds."
	end

	def check_url(url)
		extras = {:action=>"check.url", 
			:token=>@token, :url=>url}
		doc=create_request_parse_response(extras, debug=false)
		puts "Error: ", doc[:results]["errortext"] if doc[:results]["errortext"]
		if((doc[:results][:urls]) and (doc[:results][:urls].length >0))
			for u in doc[:results][:urls]
				if u["url"] == url
					puts "URL = #{url}"
					printf "In Database = %s\n", u["in_database"]
					printf "phish id = %s\n", u["phish_id"]
					printf "phish detail page = %s\n", u["phish_detail_page"]
					printf "phish verified = %s\n", u["verified"]
					printf "verified at = %s\n", u["verified_at"]
					printf "submitted at = %s\n", u["submitted_at"]
					printf "valid = %s\n", u["valid"]
				end
			end
		end
	end

	def revoke_token
		extras = {:action=>"auth.token.revoke", 
				:api_key=>@apikey, :username=>@username,
				:token=>@token}
		doc=create_request_parse_response(extras)
		puts "Error: ", doc[:results]["errortext"] if doc[:results]["errortext"]
		ss = doc[:results]["result"] || nil
		puts "Token Revokation Result = #{ss}"
		@token = nil
	end
end


def main()
if ARGV.length > 0
	conffile = ARGV[0]
else
	conffile = 'config.yml'
end

cfg=YAML.load(File.open(conffile))
ph = PhishTank.new(cfg[:app_key],cfg[:shared_secret],cfg[:frob])
rsp = ph.ping
puts "Ping Response = #{rsp}"
if not ph.frob
	puts "Frob Requested, manually accept at: ", ph.update_frob
end
res = ph.get_frob_status
unless res
    puts "Frob in config file invalid, requesting new"
    puts "Frob Requested, manually accept at: ", ph.update_frob
    puts "Press enter once frob is accepted using the above URL"
    STDIN.gets
end
ph.get_token()
ph.check_token()
url = 'http://dve.digicallme.com/.webscr/cmd-login-run/'
ph.check_url(url)
ph.revoke_token()
end

if $0 == __FILE__
	main
end
