#!/usr/bin/ruby

class Song
	attr_reader :name, :artist, :duration
	attr_writer :duration
	@@plays = 0
	def initialize (name, artist, duration)
		@name = name
		@artist = artist
		@duration = duration
		@plays = 0;
	end
	def to_s
		"#@name -- #@artist (#@duration)"
	end
	def play
		@plays += 1
		@@plays += 1
		"#@plays, #@@plays total"
	end
end

class KaraokeSong < Song
	def initialize (name, artist, duration, lyrics)
		super(name, artist, duration)
		@lyrics = lyrics
	end
	def to_s
		super + " " + @lyrics
	end
end

class WordIndex
	attr_reader :index
	attr_writer :index
	def initialize
		@index = Hash.new { |hash, key| hash[key] = [] }
	end
	def add_to_index(obj, *phrases)
		pre_keys = []
		phrases.each do |phrase|
			phrase.scan(/\w[-\w']+/) do |word|
				word.downcase!
				pre_keys << word	
			end
		end
		pre_keys.sort!.uniq!
		pre_keys.each do |key|
#			@index[key] ||= []
			@index[key].push(obj)
		end
	end
	def lookup(word)
		puts caller
		@index[word.downcase]
	end
end

class SongList
	def initialize ()
		@songs = Array.new
		@index = WordIndex.new
	end

	def add_song (song)
		@songs.push(song)
		@index.add_to_index(song, song.name, song.artist)
		self
	end
	def pop_last
		@songs.pop
	end
	def pop_first
		@songs.shift
	end
	def [](idx)
		@songs[idx]
	end
	def lookup(word)
		@index.lookup(word)
	end
	def with_title(title)
		@songs.find { |song| song.name == title }
	end
#	def dump
#		puts "HERE!"
#		@index.index.each do |key, val|
#			puts "____ #{key} --- #{val}"
#		end
#	end
end

#mysong = Song.new("Blue", "Iskren", 15)
#puts mysong.inspect
#puts mysong

#myksong = KaraokeSong.new("Blue", "Iskren", 15, "stroy about a little gay who lives...")
#puts myksong.inspect
#puts myksong.play
#puts myksong.play
#puts myksong.play

#puts mysong.play
#puts mysong.play
#mysong2 = Song.new("haha", "sth", 120);
#puts mysong2.play
#puts mysong2.private_play

#slist = SongList.new

mylist = SongList.new
File.open("songfile") do |song_file|
	song_file.each do |line|
#		puts line
		path, duration, artist, name = line.chomp.split(/\s*\|\s*/)
#		printf("%s %s %s %s\n", path, duration, artist, name);
		min, sec = duration.scan(/\d+/)
		duration = min.to_i * 60 + sec.to_i
		artist.squeeze!(" ")
		mylist.add_song(Song.new(name, artist, duration))
	end
#	puts mylist[1]
end

#mylist.dump
puts mylist.lookup("Fats")
puts mylist.lookup("ain't")
puts mylist.lookup("RED")
puts mylist.lookup("WoRlD")
puts mylist.class.class


module Test
  State = {}
  def state=(value)
    State[self.object_id] = value
  end
  def state
    State[self.object_id]
  end
  def return_hash_id
  	State.object_id.to_s
  end
end

class Client
  include Test
end


c1 = Client.new
c2 = Client.new
c1.state = "cat"
c2.state = "dog"
puts "#{c1.state} #{c1.return_hash_id}"
puts "#{c2.state} #{c2.return_hash_id}"
