#!/usr/bin/ruby

require 'date'

def expand_time(time)
	days = hours = min = sec = 0
	if time =~ /(\d+)-(\d+):(\d+):(\d)/ then
		days,hours,min,sec = $1,$2,$3,$4 #time.split ("-:")
		return "#{days} days #{hours} hours #{min} minutes #{sec} seconds"
	elsif time =~ /(\d+):(\d+):(\d+)/ then
		hours,min,sec = $1,$2,$3
		return "#{hours} hours #{min} minutes #{sec} seconds"
	else
		time =~ /(\d+):(\d+)/
		min,sec = $1,$2
		return "#{min} minutes #{sec} seconds"
	end
end

##############
# screen saver
##############

res = `ps -C kdesktop_lock -o args,etime --no-headers`
res.chomp!
if res.empty?
	puts "Screen Saver: OFF"
else
	args = `ps -C kdesktop_lock -o args --no-headers`
	args.chomp!
	automatic = (args =~ /--forcelock/ ? false : true)
	time = `ps -C kdesktop_lock -o etime --no-headers`
	puts "Screen Saver: ON #{automatic ? 'auto' : 'manual'} for #{expand_time(time)}"
end

##############
# music player
##############

radio_tbl = {
	  "fresh" => "Radio Fresh (HQ)",
	  "fresh_low.ogg" => "Radio Fresh (LQ)",
	  "radio1.ogg" => "Radio 1 (HQ)",
	  "radio1_low.ogg" => "Radio 1 (LQ)",
	  "hitradio" => "Hit Radio"
}

res = `ps -C mocp -o pid,etime --no-headers`
res.chomp!
if res.empty?
	puts "Music Player: OFF"
else
	puts "Music Player: mocp"
	pid,time = res.split(" ")
	hr_time = expand_time(time)
#	puts hr_time
	puts "\tON for #{hr_time}"

	res = `mocp -i 2> /dev/null`
#	res =~ /State: (.*?)/
	res =~ /State: (.*)/
	state = $1
	if state == "STOP" then
		puts "\tNOT playing"
	else
		res =~ /File: (.*)/
		file = $1
		if file =~ %r{http://.*/([^/]*)} :
			radio = $1
			res =~ /CurrentTime: (.*)/
			ctm = $1
			if ctm =~ /(\d+)m$/ :
				min,sec = $1,0
			else
				min,sec = ctm.split(":")
			end
			puts "\tListening to online radio \"#{radio_tbl[radio]}\" for #{min} minutes #{"and #{sec} seconds " if sec.to_i != 0}URL:\"#{file}\""
		else
			file =~ /.*\/([^\/]*)(\.(mp3|ogg))$/
			song_name = $1
			file =~ %r{/home/iskren/(.*)}
			url_song = "http://iskren.info/#$1"
			puts "\tListening to local song <a href=\"#{url_song}\">#{song_name}</a>"
		end
	end
end


##############
# video player
##############
res = `ps -C xine -o pid,etime --no-headers`
res.chomp!

if ! res.empty?
	puts "Vide Player: xine"
	pid,time = res.split(" ")
	puts "\tON for #{expand_time(time)}"
	file = `lsof | grep xine | egrep '(.avi|.mpg|.mpeg)$'`
	file.chomp!
	file =~ %r{/([^/]*)$}
	puts "\tPlaying file: \"#{$1}\""
#	puts $1
#	puts file
elsif ! (res = `ps -C mplayer -o pid,etime --no-headers`).empty?
	puts "Video Player: mplayer"
	pid,time = res.split(" ")
	puts "\tON for #{expand_time(time)}"
	file = `lsof | grep mplayer | egrep '(.avi|.mpg|.mpeg)$'`
	file.chomp!
	file =~ %r{/([^/]*)$}
	puts "\tPlaying file: \"#{$1}\""
else
	puts "Video Player: OFF"
end

##########
# compiler
##########

cdate = DateTime.parse(`date`)
lcdate = DateTime.parse(`cat ~/.last_compile_date`)
diff = cdate - lcdate

h,m,s,ff = DateTime.day_fraction_to_time(diff)
puts "Last compilation occured before #{h} hours #{m} minutes #{s} seconds"

########
# uptime
########

uptime = `uptime`

if uptime =~ %r{(\d+)\s+days,\s+(\d+):(\d+)} :
	days,hours,mins = $1.to_i,$2.to_i,$3.to_i
else
	uptime =~ %r{(\d+):(\d+)}
	days,hours,mins = 0,$1.to_i,$2.to_i
end
puts "Uptime: #{days} day#{"s" if days != 1} #{"and " if mins == 0}#{hours} hour#{"s" if hours != 1} #{"and #{mins} minute#{"s" if mins != 1}" if mins != 0}"
#puts "uptime: #{uptime}"
#puts "uptime " + `uptime`.chomp!
