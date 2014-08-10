#!/usr/bin/ruby

# DVD Game
#
# Copyright 2004 Dave Burt and Ben Wilson
#
# Credits
# Story: Ben Wilson
# Programming: Dave Burt <dave at burt.id.au>
# Inspiration: Jef Reinten
#
# Created: 21 Oct 2004
# Last modified: 10 Feb 2005
#
# Fine print: Provided as is. Use at your own risk. Unauthorized copying is not
#             disallowed. Credit's required if you use any of our code or
#             story. I'd appreciate seeing any modifications you make to it.

class GameObj
	attr_accessor :name, :desc, :seen_this
	
	def initialize(name, desc)
		@name = name
		@desc = desc
		@seen_this = false
	end
	
	def to_s; name; end
	
	def l; look; end
	def look; describe_long; end
	def describe
		if seen_this
			describe_short
		else
			describe_long
		end
	end
	def describe_short
		puts "You see #{name}."
	end
	def describe_long
		puts desc
		@seen_this = true
	end
	
	def drop
		if Location === self.class
			puts "Drop what?"
		elsif Person === self.class
			puts "You're not even going out."
		elsif $self.things.include?(self)
			puts "You drop #{self}."
			$location.things << $self.things.delete(self)
		elsif $location.things.include?(self)
			puts "You don't have #{self}."
		else
			puts "You don't see #{self} here."
		end
	end
	
	def take; get; end
	def get
		if Location === self
			puts "Get what?"
		elsif Person === self
			puts "Get #{name} how?"
		elsif $location.things.include?(self)
			puts "You pick up #{self}."
			$self.things << $location.things.delete(self)
		elsif $self.things.include?(self)
			puts "You already have #{self}."
		else
			catch(:done) do
				$location.things.each do |thing|
					if thing.respond_to?(:things) && thing.things.include?(self)
						puts "You can't just take #{thing}'s stuff."
						throw :done
					end
				end
				puts "You don't see #{self} here."
			end
		end
	end
	
	def offer; give; end
	def trade; give; end
	def give
		if Person === self.class
			puts "Give #{self} what?"
		elsif Location === self.class
			drop
		elsif !$self.things.include?(self)
			puts "You can't give what you don't have."
		else
			puts "Nobody here wants that."
		end
	end
end

class Person < GameObj
	attr_accessor :things
	def initialize(name, desc)
		super(name, desc)
		@things = []
	end
	
	def talk
		puts "You exchange a few meaningless trivialities."
	end
	def speak; talk; end
	def say; talk; end
	def chat; talk; end

	def beat; roll; end
	def mug; roll; end
	def attack; roll; end
	def hit; roll; end
	def rob; roll; end
	def kick; roll; end
	def kill
		puts "That's horrible! How could you even think of such a thing? I'm going to tell your mother."
	end
	def roll
		puts "Violence isn't the answer. This time."
	end
end

class Location < GameObj
	attr_accessor :things, :exits
	
	def initialize(name, desc)
		super(name, desc)
		@things = []
		@exits = {}
	end
	
	def describe
		if seen_this
			describe_short
		else
			describe_long
		end
	end
	def describe_short
		puts "You are at #{name}."
	end
	def describe_long
		puts "You look around #{name}."
		super
		describe_things
		describe_exits
	end
	def describe_things
		things.each do |thing|
			thing.describe
		end
	end
	def describe_exits
		print "Obvious exits are: "
		exits.each_pair do |dir, loc|
			print "#{dir} to #{loc}, "
		end
		puts "and that's all."
	end
	
	def go(dir = nil)
		if dir.nil?
			puts "Go where?"
		elsif exits.has_key?(dir)
			$location = exits[dir]
			$location.describe
		else
			puts "You can't go that direction from here."
		end
	end
	def n; go('north'); end
	def s; go('south'); end
	def e; go('east'); end
	def w; go('west'); end
	def north; go('north'); end
	def south; go('south'); end
	def east; go('east'); end
	def west; go('west'); end
end


# objects

$vehicles = GameObj.new('the available Vehicles', "Your Hog and your Dodgy housemate's Ute are in the garage.")

$watch = GameObj.new('Gold watch', "It's gold, Jerry, gold!")
class << $watch
	def give
		if !$self.things.include?(self)
			puts "You can't give what you don't have."
		elsif $location.things.include?($dodgy_housemate) && $dodgy_housemate.things.include?($stash)
			$self.points += 1
			puts "You give your Dodgy housemate the Homeless guy's Gold watch. He chortles\nand gives you his Stash in return. He strokes the Watch like a kitten."
			$dodgy_housemate.things << $self.things.delete($watch)
			$self.things << $dodgy_housemate.things.delete($stash)
		else
			puts "Nobody here wants that."
		end
	end
end

$shoes = GameObj.new("Old man's worn-out shoes", "These are the shoes (if you can call these ancient, flimsy, holey rags that)\nyou purloined from that helpless homeless guy. You can distinguish his fresh blood from the\nthick coating of anonymous grime.")
class << $shoes
end

$stash = GameObj.new('Stash', "The thought strikes you that the strange smell you've been noticing in the\ncarpet and this small collection could somehow be related.\nBut you dismiss the thought.")
class << $stash
end

$nothing = GameObj.new('the DVD', "It's about... something like... it started... You can't recall the story. In\nfact, you're not sure it had a plot at all. Billed as 'one girl's journey to\nwomanhood', or something like that, you can't remember wasting time so\npointlessly.")
class << $nothing
end

$rocket_fuel = GameObj.new('Rocket fuel', "There's a special on Rocket fuel.")
class << $rocket_fuel
	def buy; get; end
	def purchase; get; end
	def get
		if /special/.match(@desc)
			if $self.things.include?($money)
				$self.things.delete($money)
				super
				$self.points += 1
				@desc = "Apparently, burns from this stuff are proven to be 88 times more painful and\nhumourous than normal burns."
				look
      else
				puts "And how are you planning to pay for this?"
			end
    else
    	super
		end
	end
end

$money = GameObj.new('Big money', 'A pile of ill-gotten money. Jack.')
class << $money
end


# npcs

$dodgy_housemate = Person.new('your Dodgy Housemate', "Your Dodgy housemate is standing around, looking at his stuff.")
class << $dodgy_housemate
	def desc
		"Your Dodgy housemate is standing around, looking at his #{things.join(' and ')}."
	end
end
$dodgy_housemate.things << $stash

$checkout_wench = Person.new('a Checkout wench', "A starving Checkout wench is standing alone at the counter. She looks poor and\nhungry. You'd feel sorry for her, but she probably voted Labor. On purpose.")
class << $checkout_wench
end

$homeless_guy = Person.new('a Homeless guy', "A Homeless guy snuffles on the ground while he plays with his Gold watch, his\nonly possession of value.")
class << $homeless_guy
	def kill
		puts "That's horrible! How could you even think of... well, maybe just a little."
		roll
	end
	def roll
		if $homeless_guy.things.include?($shoes)
			$self.points += 1
			puts "Despite his feeble protest, you steal the old man's Shoes and with them Beat\nthe Everloving shit out of him. As an afterthought you take his Watch."
			$self.things << things.delete($shoes)
			$self.things << things.delete($watch)
			@desc = 'A Homeless guy gasps and splutters on the ground, desperately trying not to Drown in his own blood.'
		else
			puts "You lay in another boot, just for fun. The guy whimpers."
		end
	end
end
$homeless_guy.things << $shoes
$homeless_guy.things << $watch

$dirty_bitch = Person.new('that Dirty bitch', "The Dirty bitch must be inside, slooowwly closing shop...")
class << $dirty_bitch
	def burn; immolate; end
	def ignite; immolate; end
	def torch; immolate; end
	def light; immolate; end
	def immolate
		if $self.things.include?($rocket_fuel)
			$self.points += 1
			puts "As the DIRTY BITCH leaves to go to her car, you DOUSE HER WITH ROCKET FUEL, and\nSET HER ON FIRE. Umm... let's leave the next bit to the imagination. I mean,\nreally, do you want me to describe, in detail, the horrible death of a lonely\nold woman? I mean, what kind of a sick fuck are you anyways?" 
			puts "You seem to have just won the game. You collected #{$self.points} points out of 5 to be had."
			exit
		else
			puts "You try to breathe fire all over her just like a dragon, and fail."
		end
	end
end



# locations

$woodside_ave = Location.new('Woodside Avenue', "A strange smell emanates from the carpet.")
class << $woodside_ave
end
$woodside_ave.things << $dodgy_housemate
$woodside_ave.things << $vehicles


$bilo = Location.new('BI-LO', "There's groceries.")
class << $bilo
end
$bilo.things << $rocket_fuel
$bilo.things << $checkout_wench

$nature_trail = Location.new('the Nature Trail', "Except for the rubbish and mud, it's quite beautiful.")
class << $nature_trail
end
$nature_trail.things << $homeless_guy

$cop_shop = Location.new('the Cop shop', "You're standing in front of the Cop shop. A reward notice offers Big money for\nevidence leading to the arrest of Dodgy stoner-type people.")
class << $cop_shop
end

$movieland = Location.new('Movieland', "You're standing outside Movieland. Despite the fact that it's supposed to close\nin five minutes, the Dirty bitch has locked the doors and won't let you in.\nLooks like you're going to cop a fine.")
class << $movieland
end
$movieland.things << $dirty_bitch

$woodside_ave.exits = {'south' => $bilo}
$bilo.exits = {'north' => $woodside_ave, 'west' => $nature_trail}
$nature_trail.exits = {'south' => $cop_shop, 'east' => $bilo}
$cop_shop.exits = {'north' => $nature_trail, 'south' => $movieland}
$movieland.exits = {'north' => $cop_shop}



# player

$self = Person.new('Yourself', 'You see a devilishly handsome person')
class << $self
	attr_accessor :points

	def i
		inventory
	end
	def inventory
		if things.empty?
			puts "You have: nothing!"
		else
			puts "You have: #{things.join(', ')}"
		end
	end
	
	def quit
		puts "Leaving already? You only managed to scrape together #{points} points."
		puts 'Bye'
		exit
	end
	def score
		puts "You have a measly #{points} points. Keep trying."
	end
	def q
		quit
	end

	def go_jack
		if $self.things.include?($stash) && $cop_shop.seen_this
			puts "You take the Stash into the Cop shop, and explain where you got it from. You savor the thought of the look on your Dodgy housemate's face when he gets forty to life for possesion. Oh well, guy needed A Good bubba-style rodgering anyways."
			$self.things.delete($stash)
			$self.things << $money
			$self.points += 1
			$woodside_ave.things.delete($dodgy_housemate)
			$woodside_ave.desc += " Your Dodgy housemate is gone. Ride on, ride on, for the inmates!"
			$location = $cop_shop
		else
			puts "What? How?"
		end
	end
	
	def kill
		puts "Why would you do that to yourself? You have #{points} points. That's more than #{points - 1}!"
	end
	def roll
		puts "You give yourself a good smack upside the head to let yourself know who's boss."
		puts "You reel for a second. Now on with the quest!"
	end
end
$self.things << $nothing
$self.points = 0



def act_on_input(command)
	
	command.strip!
	command.downcase!
	
	catch (:ok) do

		# special vocab
		
		if /jack/.match(command) || /screw/.match(command)
			if $woodside_ave.things.include?($dodgy_housemate)
				$self.go_jack
				throw :ok
			else
				puts "You've already beaten a random old man senseless and gone jack on your housemate. You need to find someone new to screw over."
			end
		end
		
		# normal verb subject processing (send verb to subject)
		
		verb, subject, ignored_stuff = command.split(' ', 3)
		verb = 'do nothing' if !verb
	
		if subject.nil?
			[$location, $self].each do |target|
				if target.respond_to?(verb)
					target.send(verb)
					throw :ok
				end
			end
		else
			subject = Regexp.new(subject)
			($self.things + $location.things + [$location, $self]).each do |thing|
				if subject.match(thing.name.downcase) && thing.respond_to?(verb)
					thing.send(verb)
					throw :ok
				end
			end
			$location.things.each do |thing|
				if thing.respond_to? :things
					thing.things.each do |thing|
						if subject.match(thing.name.downcase) && thing.respond_to?(verb)
							thing.send(verb)
							throw :ok
						end
					end
				end
			end
		end
		
		if /shit/.match(command) || /fuck/.match(command)
			puts "Your response has been logged and sent to your mother."
		else
			puts "You can't #{verb} #{subject ? 'that' : 'here'}!"
		end
	end
end


def exit
	gets
	Kernel.exit
end

# initial game state

$location = $woodside_ave


# intro

puts <<-EOS









The DVD Game

Copyright 2004 Dave Burt and Ben Wilson

         -    --  --------------------------------------===================####



You have 15 minutes left to return the DVD.

EOS

$location.describe

print '> '

puts <<-EOS
You're just about to #{gets.chomp.strip}, when a meteor hits the carport,
and destroys all vehicles therein.
You're walking. Better get cracking.
EOS

$location.things.delete($vehicles)

# main loop

loop do

	print '> '
	act_on_input(gets.chomp!)

end
