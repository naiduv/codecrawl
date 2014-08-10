#!/usr/bin/ruby

# RiPPER wRaPPER
# --------------
# A ruby wrapper of cdparanoia, flac, and metaflac for ripping CDs
# to FLAC 
# Copyright 2007 by Clay Barnes (clay.barnes@gmail.com)
# Licenced under the GPL v2.0 (or later)
# 
# Stuff to do:
# ------------
# FIX CRASHES WITH MULTI-ARTIST MIXED RANGES
# Add command-line processing for whether to eject, preferred CD device, target dir, filename format, etc.
# Clean out some of the cdparanoia output crap
# Watch for encode process completion?
# Child process niceness settings?
# Enable arrow-key movement in entry boxes
# ncurses foobar input for seeding input?
# FreeDB lookups?

def bashEscapeString(string)
	string.gsub("'"){"'\\''"}		# shells require string-ending ', escaped \' and restarting with '
end

def bashEscapeFilename(string)
	string = bashEscapeString(string)	# do escaping necessary for '' quoting
	string.gsub("/"){"_"}			# replace / with _ because it's not a valid name
end

def parseRanges(line)
	# Extract Ranges
	ranges = line.scan(/\d+-\d+/)
	# Extract individual values
	values = line.scan(/\d+/).map{|e| e.to_i}
	# For each range, add every value in it
	for i in ranges do
		ends = i.split("-")
		if ends.first.to_i < ends.last.to_i then
			for i in ends.first.to_i...ends.last.to_i do values += [i] end
		else
			for i in ends.last.to_i...ends.first.to_i do values += [i] end
		end
	end
	
	# Don't run .uniq! on arrays with only one value
	if values.size > 1 then values = values.uniq!.sort end 

	values
end

def printQuery()
	puts "Choose:"
	puts "l) List current metadata"
	puts "r) Rip all tracks"
	puts "s [tracks list]) Rip select tracks (ex. s1 2 4-6 3)"
	puts "p##) Play/preview track ## (ex. p11)"
	puts "##=[value]) Set value ## to [value] (ex. 1=Air)"
	puts "h) list this help message"
	puts "q) Quit"
end

def readyDrive(devicePath)
	# Check drive status
	cdparanoia = "/usr/bin/cdparanoia -c " + devicePath + " -Q 2>&1"
	output = `#{cdparanoia}`
	until $?.success? do
		puts "Drive /dev/cdrom not reporting an audio CD.  Hit [enter] when ready, or ctrl+c to abort."
		gets
		output = `#{cdparanoia}`
	end
	
	tracks = output.grep(/^ *\d+.|^=+|^track/)
end

def getAlbumInfo(devicePath)
	trackArtists = [""]	# NOTE:  We're using 1-indexing here!
	trackTitles = [""]	# NOTE:  We're using 1-indexing here!
	trackTimes = [""]	# NOTE:  We're using 1-indexing here!
	
	# Get general information on the album
	puts "Is this a compilation/multi-artist album? (y/n)"
	if readline.capitalize[0,1] == "Y" then
		isCompilation = true
	end
	
	puts "Offset the tracknumbers by (for multi-disc albums), enter for none:"
	offset = readline
	offset = offset.to_i
	
	if !isCompilation then
		puts "Enter Album Artist:"
		artist = readline.chop
	end
	
	puts "Enter Album Title:"
	albumTitle = readline.chop
	
	puts "Enter Album Year:"
	albumYear = readline.chop

	tracks = readyDrive( devicePath )
	trackCount = tracks.size - 2

	# Get track titles
	for i in 1..trackCount do
		trackTimes[i] = tracks[i+1].match(/\d\d:\d\d\.\d\d/)
		if isCompilation then
			puts "Enter artist for track "+i.to_s+", length "+trackTimes[i].to_s
			trackArtists[i] = readline.chop
			puts "Enter title:"
			trackTitles[i] = readline.chop
		else 
			puts "Enter title for track "+i.to_s+", length "+trackTimes[i].to_s
			trackTitles[i] = readline.chop
		end
	end

	infoArray = [isCompilation, offset, artist, albumTitle, albumYear, trackArtists, trackTitles, trackTimes, trackCount]

end

def printStatus(artist, albumTitle, albumYear, trackArtists, trackTitles, trackTimes, isCompilation, offset)
	puts "\nTrack offset: " + offset.to_s
	if isCompilation then
		puts "Compilation: Yes\nArtist: [COMPILATION]"
	else 
		puts "Compilation: No\n-3 ] Artist: '" + artist + "'"
	end
	puts "-2 ] Album Title: '" + albumTitle + "'\n-1 ] Year ("+albumYear+")"
	
	#for i in 1...trackTitles.size do
		#if !trackTitles[i] then
			#trackTitles[i] = ""
		#end
	#end
	longestTrack = trackTitles.max{ |a,b| a.length <=> b.length }.length
	for i in 1..(longestTrack+16) do printf("-") end
	puts ""
	for i in 1...trackTitles.size do
		if isCompilation then printf("%2da] (Track Artist) '%s'\n", i, trackArtists[i]) end
		printf("%2d ] (%8s) '%s'\n", i, trackTimes[i], trackTitles[i])
	end
	puts ""
end

def ripDisc(tracks, artist, albumTitle, albumYear, trackArtists, trackTitles, isCompilation, offset)
	for i in tracks do
		# Ripping target directory
		if !(artist) then artist = "[COMPILATION]" end
		ripdir = "./" + bashEscapeFilename(artist) + "/(" + bashEscapeFilename(albumYear) + ") " + bashEscapeFilename(albumTitle) + "/"

		# Filename for target of rip
		ripname = (i + offset).to_s
		if !ripname[1] then ripname = "0" + ripname end
		ripname += " - "
		if isCompilation then ripname += trackArtists[i] + " - " end
		ripname += trackTitles[i] + ".flac"
		ripname = bashEscapeFilename( ripname )

		# Temporary filename
		tempname = bashEscapeFilename( artist + " - " + albumTitle + " - Track "  + (i + offset).to_s + ".wav" )

		# Directory creation command
		mkdircmd =  "mkdir -p '"+ripdir+"'"

		# Ripping command
		#ripcmd = "cdparanoia -z " + i.to_s + " '" + tempname + "' 2>&1 | sed -n 10~1p"
		ripcmd = "cdparanoia -z " + i.to_s + " '" + tempname + "' 2>&1"
		
		# Encoding command
		enccmd = "flac '" + tempname + "' -8 --totally-silent --delete-input-file -o '" + ripdir + ripname + "'"

		# Tagging command
		tagcmd = ""
		tmpArtist = artist
		if isCompilation then 
			tagcmd += "metaflac --set-tag='COMPILATION=yes' '" + ripdir + ripname + "' ;\n"
			#tagcmd += "metaflac --set-tag='AlbumArtist=" + bashEscapeString(artist) + "' '" + ripdir + ripname + "' ;\n"
			tmpArtist = trackArtists[i]
		end
		tagcmd += "metaflac --set-tag='Artist=" + bashEscapeString(tmpArtist) + "' '" + ripdir + ripname + "' ;\n"
		tagcmd += "metaflac --set-tag='Album=" + bashEscapeString(albumTitle) + "' '" + ripdir + ripname + "' ;\n"
		tagcmd += "metaflac --set-tag='Title=" + bashEscapeString(trackTitles[i]) + "' '" + ripdir + ripname + "' ;\n"
		tagcmd += "metaflac --set-tag='Date=" + bashEscapeString(albumYear) + "' '" + ripdir + ripname + "' ;\n"
		tagcmd += "metaflac --set-tag='TrackNumber=" + (i + offset).to_s + "' '" + ripdir + ripname + "' "

		# Execute compiled commands
		#puts mkdircmd
		puts ripcmd
		puts enccmd
		#puts tagcmd

		system( mkdircmd )
		system( ripcmd )
		fork{`#{enccmd + " && " + tagcmd}`}
	end
end

def main()

devicePath = "/dev/cdrom/"
infoArray = getAlbumInfo(devicePath)

isCompilation = infoArray[0]
offset = infoArray[1]
artist = infoArray[2]
albumTitle = infoArray[3]
albumYear = infoArray[4]
trackArtists = infoArray[5]
trackTitles = infoArray[6]
trackTimes = infoArray[7]
trackCount = infoArray[8]


printStatus(artist, albumTitle, albumYear, trackArtists, trackTitles, trackTimes, isCompilation, offset)
printQuery()

line = ""								# initalize line so it doesn't block this loop
while line								# until EOF (allows scripting, perhaps?)
	line = readline							# get the user's desired actions
	line = line.chomp!						# banish that newline!
	if line[0,1].index(/[Ll]/) then					# if the user wants to see the new listing
		printStatus(artist, albumTitle, albumYear, trackArtists, trackTitles, trackTimes, isCompilation, offset)
		
	elsif line[0,1].index(/[Hh]/) then				# if the user wants help
		printQuery()
	
	elsif line[0,1].index(/[Rr]/) then				# if the user wants to rip the whole CD
		puts "Ripping tracks 1-" + trackCount.to_s
		tracks = parseRanges("1-"+trackCount.to_s)		# use the whole CD as the range
		ripDisc(tracks[0,trackCount], artist, albumTitle, albumYear, trackArtists, trackTitles, isCompilation, offset) # RIP!
		system( "eject /dev/cdrom" )
		printQuery()
		#exit							# nothing else this program can do!
		
	elsif line[0,1].index(/[Pp]/) then				# preview the track
		system( "cdplay " + line[2,4].to_i.to_s + "-" + line[2,4].to_i.to_s )
		puts "Press [enter] to stop playback and return to menu."
		gets
		system( "cdplay stop" )
		
	elsif line[0,1].index(/[Ss]/) then				# if the user wants to rip only some tracks
		#puts "Enter tracks to rip as space-seperated integers or ranges(2-3) (e.x '4 6-9 2'):"
		line = line[1,line.length]
		tracks = parseRanges(line)				# parse the given ranges
		ripDisc(tracks[0,trackCount], artist, albumTitle, albumYear, trackArtists, trackTitles, isCompilation, offset) # RIP!
		puts "Finished ripping (but possibly not encoding) tracks!"
									# don't quit like with R, just in case
		
	elsif line[0,1].index(/[Qq]/) then				# if they want to quit...
		exit							# then quit!
		
	elsif line.index("=") and line[0,line.index("=")].index(/\d/) then # make sure we have = preceeded by a number
		if line[0,line.index("=")].index(/[aA]/) then		# see if we have an a/A in there
			if line[line.index("=")+1, line.length] then	# make sure we have something past the =
				trackArtists[line.to_i] = line[line.index("=")+1, line.length] # set the artist[i]
			end
		elsif line[0,line.index("=")].index("-2") then		# if we got the change AlbumTitle number
			if line[line.index("=")+1, line.length] then	# make sure we have something past the =
				albumTitle = line[line.index("=")+1, line.length] # set the albumTitle
			end
		elsif line[0,line.index("=")].index("-1") then		# if we got the change AlbumTitle number
			if line[line.index("=")+1, line.length] then	# make sure we have something past the =
				albumYear = line[line.index("=")+1, line.length] # set the albumTitle
			end
		else							# since we don't have an a/A in there
			if line[line.index("=")+1, line.length] then	# make sure we have something past the =
				trackTitles[line.to_i] = line[line.index("=")+1, line.length] # set the title[i]
			end
		end
	end
end

end

main()
