#!/usr/bin/ruby
# Create display override file to force Mac OS X to use RGB mode for Display
# see http://embdev.net/topic/284710
 
require 'base64'
 
data=`ioreg -l -d0 -w 0 -r -c AppleDisplay`
 
edids=data.scan(/IODisplayEDID.*?<([a-z0-9]+)>/i).flatten
vendorids=data.scan(/DisplayVendorID.*?([0-9]+)/i).flatten
productids=data.scan(/DisplayProductID.*?([0-9]+)/i).flatten
 
displays = []
edids.each_with_index do |edid, i|
    disp = { "edid_hex"=>edid, "vendorid"=>vendorids[i].to_i, "productid"=>productids[i].to_i }
    displays.push(disp)
end
 
# Process all displays
if displays.length > 1
    puts "Found %d displays!  You should only install the override file for the one which" % displays.length
    puts "is giving you problems.","\n"
end
displays.each do |disp|
# Retrieve monitor model from EDID data
monitor_name=[disp["edid_hex"].match(/000000fc00(.*?)0a/){|m|m[1]}].pack("H*")
if monitor_name.empty?
    monitor_name = "Display"
end
 
puts "found display '#{monitor_name}': vendorid #{disp["vendorid"]}, productid #{disp["productid"]}, EDID:\n#{disp["edid_hex"]}"
 
bytes=disp["edid_hex"].scan(/../).map{|x|Integer("0x#{x}")}.flatten
 
puts "Setting color support to RGB 4:4:4 only"
bytes[24] &= ~(0b11000)
 
puts "Number of extension blocks: #{bytes[126]}"
puts "removing extension block"
bytes = bytes[0..127]
bytes[126] = 0
 
bytes[127] = (0x100-(bytes[0..126].reduce(:+) % 256)) % 256
puts
puts "Recalculated checksum: 0x%x" % bytes[127]
puts "new EDID:\n#{bytes.map{|b|"%02X"%b}.join}"
puts
puts
puts '====== TAKE THE FOLLOWING STEPS: =========='
puts
puts '1. Create a new folder in /System/Library/Displays/Overrides/'
puts "2. Name it 'DisplayVendorID-#{disp["vendorid"]}' (if there\'s already a folder with that name then rename it, as backup)."
puts '3. In that folder create a new text file with the following content:'
puts
puts '------ file content below this line ----------'
puts '<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">'
puts "<dict>
  <key>DisplayProductName</key>
  <string>#{monitor_name} - forced RGB mode (EDID override)</string>
  <key>IODisplayEDID</key>
  <data>#{Base64.encode64(bytes.pack('C*'))}</data>
  <key>DisplayVendorID</key>
  <integer>#{disp["vendorid"]}</integer>
  <key>DisplayProductID</key>
  <integer>#{disp["productid"]}</integer>
</dict>
</plist>"
puts '------ file content above this line ----------'
puts
puts "4. Save the file with filename: DisplayProductID-%x" % disp["productid"]
puts '5. Restart your computer.'
puts "\n"
end		# displays.each