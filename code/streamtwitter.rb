require "rubygems"
require "json"
require "net/http"
require "uri"


puts ""
puts "Enter your Twitter username:"
username = gets.chomp

puts ""
puts "Enter your Twitter password:"
password = gets.chomp

puts ""
puts "Enter a search term (or leave blank to search for 'google'):"
search_term = gets.chomp

puts ""
puts "Starting stream..."
puts ""


# create place to store tweets, so we hold them for later
all_returned_tweets = String.new
# catch CTRL+C and then write tweets to file is the user wants to
trap :INT do
  puts ""
  puts ""
  puts "Do you want to save this stream to a text file? (Y or N)"
  create_file = gets.chomp
  if create_file.length > 0 && create_file.slice(0,1).downcase == 'y' && all_returned_tweets.length > 0
    puts ""
    puts "Enter the filename you would like:"
    twitter_filename = gets.chomp

    # create a new file and write to it
    File.open(twitter_filename, 'w') do |twit_file|
      twit_file.puts all_returned_tweets
    end
  end
  puts ""
  exit
end


search_term = search_term.length != 0 ? search_term : 'google'
uri = URI.parse("http://stream.twitter.com/1/statuses/filter.json")

# set up the HTTP request
http = Net::HTTP.new(uri.host, uri.port)
request = Net::HTTP::Post.new(uri.request_uri)
request.basic_auth username, password
request.set_form_data({'track' => search_term})

# make the HTTP request
http.request(request) do |response|
  if response.is_a?(Net::HTTPSuccess)
    response.read_body do |chunk|
      # silently discard tweets with malformed JSON & roll on
      begin
        if (tweet = JSON.parse(chunk)) && (!tweet['delete'])
          puts ''
          puts ' '+ tweet['text'] +' : '+ tweet['user']['screen_name']
          all_returned_tweets += tweet['text'] +' : '+ tweet['user']['screen_name'] +"\n"
        end
      rescue
      end
    end
  else
    puts ""
    puts ' *** There was a Twitter connection error. For starters, check your username/password. ***'
    puts ""
  end
end
