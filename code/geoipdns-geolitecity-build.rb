#!/usr/local/bin/ruby

# Usage:
#   Enter a directory contaning GeoLiteCity-Location.csv and GeoLiteCity-Blocks.csv
#   from MaxMind's GeoCityLite database. Available here: http://www.maxmind.com/app/geolitecity
#   Execute the script:
#
#   ./geoipdns-geolitecity-build.rb
#
#   This will create or replace geoipdata.csv in the same directory.
#
# Thanks to Wejn of http://wejn.org/ for massive speedups in this code

# Ruby 1.9 doesn't play along well with us by default; let's turn off encoding
if RUBY_VERSION >= "1.9"
	Encoding.default_external = Encoding::ASCII_8BIT
	Encoding.default_internal = Encoding::ASCII_8BIT
end

# CIDRCompress module by Wejn, see http://wejn.org/
module CIDRCompress
	def inet_ntoa(n)
		[n].pack("N").unpack("C*").join "."
	end

	def inet_aton(ip)
		return ip.to_i if /^\d+$/ =~ ip
		raise ArgumentError, "invalid IP: #{ip}" unless /^(\d+\.){3}\d+$/ =~ ip
		ip.split(/\./).map{|c| c.to_i}.pack("C*").unpack("N").first
	end

	def ranges_for(f, l, &b)
		# adapted from: http://phix.me/geodns/#script
		# as my previous version was much less elegant

		raise LocalJumpError, "no block given" unless block_given?

		# auto-convert IPs
		f = inet_aton(f) unless f.kind_of?(Integer)
		l = inet_aton(l) unless l.kind_of?(Integer)

		# flip first,last if first > last
		f, l = l, f if f > l

		# do the magic
		log = (Math.log(l-f+1)/Math.log(2)).to_i # log10(x)/log10(2) == log2(x)
		mask = 2**32 - 2**log

		if f&mask == l&mask
			b.call(inet_ntoa(f), 32-log)
		else
			ranges_for(f, (l&mask)-1, &b)
			ranges_for(l&mask, l, &b)
		end
	end


	# make it both includable and directly callable
	class <<self; include CIDRCompress; end
end

puts "Reading GeoLiteCity-Location.csv into memory..."

h = Hash.new

File.open("GeoLiteCity-Location.csv").each do |ln|
	next unless (?0..?9).include?(ln[0])
	k, s = ln.split(',', 2)
	h[k] = s
end

puts "Processing GeoLiteCity-Blocks.csv..."

File.open( "geoipdata.csv", "w" ) do |out_file|
	out_file.write( "network,country,region,city,postalCode,latitude,longitude,metroCode,areaCode\n" )

	File.open("GeoLiteCity-Blocks.csv").each do |ln|
		next unless ln[0] == ?"
		s = ln.match( '"(\d+)","(\d+)","(\d+)"' )
		next unless s[3].length > 0 # skip unless we have a third param (ie: we have a successful parse)
		CIDRCompress.ranges_for(s[1].to_i, s[2].to_i) do |a,m|
			out_file.write( "\"#{[a,m].join('/')}\",#{h[s[3]]}" )
		end
	end
end
