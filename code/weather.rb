#!/usr/bin/ruby
require 'net/http'
require 'xmlsimple'

# This script fetches the weather from the Yahoo! Weather RSS feed and prints it out.
# This can be used for Conky, for example.
# By Brian Carper
# http://briancarper.net
#
# This script is kind of ugly.

RSS_FEED_URL = ''

if RSS_FEED_URL == '' then
    puts 'Edit the script to specify'
    puts 'your RSS feed URL from'
    puts 'http://weather.yahoo.com'
    exit
end

begin
    text = Net::HTTP.get(URI.parse(RSS_FEED_URL))
rescue
    puts "ERROR: Failed fetching RSS feed!"
    exit
end

begin
    xml = XmlSimple.xml_in(text)
    channel = xml['channel'][0]
rescue
    puts "Error: Could not parse the XML!"
    exit
end

temp_units = ' ' + channel['units'][0]['temperature']
baro_units = ' ' + channel['units'][0]['pressure']
wind_units = ' ' + channel['units'][0]['speed']

puts "Weather (" + channel['lastBuildDate'][0].sub(/..., \d\d ... \d\d\d\d /,'') + '):'
puts "    Currently: " + channel['item'][0]['condition'][0]['text'] + ', ' + channel['item'][0]['condition'][0]['temp'] + temp_units
puts "     Humidity: " + channel['atmosphere'][0]['humidity'] + '%'
puts "         Wind: " + channel['wind'][0]['speed'] + wind_units
puts "    Barometer: " + channel['atmosphere'][0]['pressure'] + baro_units
puts "      Sunrise: " + channel['astronomy'][0]['sunrise']
puts "       Sunset: " + channel['astronomy'][0]['sunset']
puts "Forecast:"
[0,1].each do |i|
    arr = channel['item'][0]['forecast'][i]
    puts "    " + arr['day'] + ': ' + arr['text'] + '.'
    puts '         High ' + arr['high'] + temp_units + ', Low ' + arr['low'] + temp_units + '.'
end
