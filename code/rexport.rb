#!/usr/bin/env ruby

require 'rexchange'
require 'digest/md5'

#Change uri and options to match your settings
#uri = 'https://myurl.example.com/exchange/my-ad-username/'
#options = { :user => 'my-login-name@example.com', :password => 'my-password' }

# set these in environment variables before you call this script.
user = ENV['_CUSER']
pass = ENV['_CPASS']
uri =  ENV['_COWAURL']

puts "user: [#{user}], uri: [#{uri}]"

options = { :user => user, :password => pass }

#Transform XML-date to simple UTC format.
def xformdate(s)
  s[0..3] + s[5..6] + s[8..12] + s[14..15] + s[17..18] + "Z"
end

# We pass our uri (pointing directly to a mailbox), and options hash to RExchange::open
# to create a RExchange::Session.
RExchange::open(uri, options) do |mailbox|
  
          #create ics file
          calfile = File.new("exchange-calendar.ics", "w")
          
          calfile.puts "BEGIN:VCALENDAR"
          #calfile.puts "CALSCALE:GREGORIAN"
          calfile.puts "PRODID:-//Apple Computer\, Inc//iCal 2.0//EN"
          calfile.puts "VERSION:2.0"
	  calfile.puts ""
          
          itemcount = 0

	  arruid = Array.new
          
          mailbox.calendar.each do |calitem|

            calfile.puts "BEGIN:VEVENT"

            # Set some properties for this event
            calfile.puts "DTSTAMP:" + xformdate(calitem.dtstamp) if calitem.dtstamp
            calfile.puts "CREATED:" + xformdate(calitem.created) if calitem.created
            calfile.puts "DTSTART:" + xformdate(calitem.dtstart) if calitem.dtstart
            calfile.puts "DTEND:" + xformdate(calitem.dtend) if calitem.dtend
            calfile.puts "LAST-MODIFIED:" + xformdate(calitem.lastmodified) if calitem.lastmodified
	    if calitem.from
		s = calitem.from
		mailto = s.gsub(/.*?<(.*?)/, '\1')
		mailto = mailto.gsub(/[<,>]/, '')
		name = s.gsub(/"(.*?), (.*?)".*/, '\2 \1')
		calfile.puts "ORGANIZER;CN=#{name}:MAILTO:#{mailto}"
	    end

	    if calitem.to
		# this looks like this:  "UL, UF" <U@C.com>, "UL, UF" <U@C.com>
	    	array = calitem.to.split(">, ")
		array.each {|s| 
			mailto = s.gsub(/.*?<(.*?)/, '\1')
			mailto = mailto.gsub(/[<,>]/, '')
			name = s.gsub(/"(.*?), (.*?)".*/, '\2 \1')
			calfile.puts "ATTENDEE;CN=#{name};ROLE=REQ-PARTICIPANT:mailto:#{mailto}"
		}
	    end
	    if calitem.cc
		# this looks like this:  "UL, UF" <U@C.com>, "UL, UF" <U@C.com>
	    	array = calitem.cc.split(">, ")
		array.each {|s| 
			mailto = s.gsub(/.*?<(.*?)/, '\1')
			mailto = mailto.gsub(/[<,>]/, '')
			name = s.gsub(/"(.*?), (.*?)".*/, '\2 \1')
			calfile.puts "ATTENDEE;CN=#{name};ROLE=OPT-PARTICIPANT:mailto:#{mailto}"
		}
	    end
            
            subj = "unknown event thingey"
            subj = calitem.subject if calitem.subject
            calfile.puts "SUMMARY:" + subj   
             
            #desc = calitem.textdescription.gsub!("\n","\\n") if calitem.textdescription
	    if ! ( calitem.textdescription.nil? || calitem.textdescription.empty?)
	    	arr = calitem.textdescription.split(/\n/)
		desc = arr.join("\\n")
	    end

            calfile.puts "DESCRIPTION:" + desc if desc
            calfile.puts "LOCATION:" + calitem.location if calitem.location
            calfile.puts "STATUS:" + calitem.meetingstatus if calitem.meetingstatus

	    # uid... we have to make sure that we have a valid one and that
	    # it is unique
	    uid = "blef_#{itemcount}"
            uid = calitem.uid if calitem.uid
	    if arruid.include?(uid)
	    	uid = "blef_#{itemcount}"
	    end
	    arruid.push(uid)
	    digest = Digest::MD5.hexdigest("#{uid}\n")
            calfile.puts "UID:" + digest

            calfile.puts "CATEGORIES:WorkXChange"
            
            if calitem.reminderoffset
              #ouput valarm details. reminderoffset is in seconds
              ro_min = calitem.reminderoffset.to_i / 60
              calfile.puts "BEGIN:VALARM"
              calfile.puts "TRIGGER;VALUE=DURATION:-PT#{ro_min}M"              
              calfile.puts "DESCRIPTION:" + subj
              calfile.puts "ACTION:DISPLAY"              
              calfile.puts "END:VALARM"
            end
            
            #add event to calendar
            calfile.puts "END:VEVENT"
	    calfile.puts ""
            
            itemcount = itemcount + 1

          end
          
          #close ical file
          calfile.puts "END:VCALENDAR"
          calfile.close
          
          p "Done! Wrote #{itemcount} appointment items"

end
