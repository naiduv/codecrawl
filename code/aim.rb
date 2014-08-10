#!/usr/bin/env ruby

# aim.rb
# Extracts AIM message data from a pcap file (evidence.pcap) and prints to screen
# By: Aaron Allen
# August 25, 2009

require 'pcaplet'

# Open up our pcap file
$evidence = Pcaplet.new('-r evidence.pcap')



# Takes a string of binary data from a reassembled AIM packet and parses out the relevant screenname and msg text
def packetParse p
    # Check channel value to ensure we are dealing with an IM message
    if p[25..25].unpack("C")[0] == 1

    # Find the length of the screenname
    snLength = p[26..26].unpack("c")
    # Find the screenname
    sn = p[27..(27 + snLength[0])]


      # Check to see if we are receiving a message
      if p[9..9].unpack("c")[0] == 7
        # The receiving message will always be contained 26 bytes after the screenname
        msgStart = 27 + snLength[0] + 26

      # We must be sending a message
      elsif p[9..9].unpack("c")[0] == 6
        # The packet contains the recipients screenname, so let's just rename the sender to 'sender'
        sn = "Sender"
        msgStart = 27 + snLength[0] + 20
      
      # This isn't an IM packet, so exit
      else
        return nil
      end
      
      # Pull the message out of the packet data
      msg = p[msgStart..(p.length-4)]
      # Strip out any unprintable binary data
      msg = msg.gsub(/[^[:print:]]/, '')
    
     
    return [sn, msg] 
        
  end
  
end


# Look for packets that are sent to the AIM server
$send_filter = Pcap::Filter.new('dst host 64.12.24.50', $evidence.capture)

# Look for packets coming from the AIM server
$recv_filter = Pcap::Filter.new('src host 64.12.24.50', $evidence.capture)

# add all the filters
$evidence.add_filter($send_filter | $recv_filter)

for p in $evidence
    if p.tcp_data
      
      # Look for the flapHeader startMarker and frameType of 2
      if (p.tcp_data[0..0] == "*") and (p.tcp_data[1..1].unpack("C")[0] == 2)
        # Get payloadLength from header data and check to see if the current packet contains entire payload
        payloadLength = p.tcp_data[5..5].unpack("C")[0]
        if p.tcp_data.length >= payloadLength
          sn, msg = packetParse p.tcp_data
        else
          # The remainder of the payload is in the next packet, put data from this packet in string 'reassembled'
          reassembled = p.tcp_data
        end
      
      # The current packet is a continuation of an AIM payload, proceed with reassembly
      elsif reassembled
        # Make sure we don't select data from a new AIM payload in the same packet
        reassembled += p.tcp_data[/.+[\*$]/]
        sn, msg = packetParse reassembled
        reassembled = nil
      end

      # Print the message
      puts "From #{sn}: #{msg}" if sn and msg
      
    end
end
