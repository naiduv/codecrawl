#!/usr/bin/env ruby
#
# This is a Jabber (XMPP) bot, which rolls dice for RPG's like Dungeons & Dragons.
# Paul Gorman (gorman.paul@gmail.com) 3 October 2010
#
require 'rubygems'
require 'xmpp4r'
require 'xmpp4r/muc/helper/simplemucclient'

if ARGV.size != 3
  puts "Usage: #{$0} <jabberid> <password> <room@conference.example.com/nick>"
  exit
end

username = ARGV[0]
password = ARGV[1]
room_and_nick = ARGV[2]
#room_and_nick = 'private-chat-00000000-0000-0000-0000-000000000123@groupchat.google.com/DiceRoller'

version = '0.9.2'
#Jabber::debug = true

def roll(term)
    total = 0
    verbose = FALSE
    result = term
    if term =~ /v.*/ # Use verbose mode.
        verbose = TRUE
        result = result.reverse.chop.reverse + ' = ('
    end
    term =~ /v?(\d*)d(\d+)\s*((\+|-)\s*(\d+))?\s*(x\s*\d+)?/
    if $1.to_i > 1 # Roll multiple dice.
        $1.to_i.times do
            roll = rand($2).to_i + 1
            total = total + roll
            if verbose
                result = result + ' ' + roll.to_s + ' '
            end
        end
    else
        total = rand($2).to_i + 1
        if verbose
            result = result + ' ' + total.to_s + ' '
        end
    end
    if $3 # Add bonus or penalty
        if $4 == '+'
            total = total + $5.to_i
        else
            total = total - $5.to_i
        end
        if verbose
            result = result + $3
        end
    end
    if verbose
        result = result + ')'
    end
    result = result + ' = ' + total.to_s
    return result
end

# Print a line formatted depending on time.nil?
def print_line(time, line)
  if time.nil?
    puts line
  else
    puts "#{time.strftime('%I:%M')} #{line}"
  end
end

xmpp = Jabber::Client.new(Jabber::JID::new(username))
xmpp.connect
xmpp.auth(password)
xmpp.send(Jabber::Presence::new.set_type(:available))

mainthread = Thread.current

bot = Jabber::MUC::SimpleMUCClient.new(xmpp)

bot.on_join { |time, nick|
    print_line time, "#{nick} joined the chat."
    puts "Users: " + bot.roster.keys.join(', ')
}

bot.on_leave { |time, nick|
    print_line time, "#{nick} left the chat."
}
bot.on_message { |time, nick, text |
    print_line time, "<#nick}> #{text}"

    unless time
        if text.strip =~ /^:roll\s+(v?\s*\d*d\d+\s*((\+|-)\s*\d+)?)(.*)$/
            # Throw dice.
            result = "#{nick} rolls " + roll($1) + " " + $4
            bot.say(result)
        elsif text.strip =~ /^:roll\s+(v?\s*\d*d\d+\s*((\+|-)\s*\d+)?)\s*(x\s*(\d+))?(.*)$/
            # Do multiple sets of throws. (Roll ability scores, etc.)
            result = "#{nick} rolls "
            $5.to_i.times do 
                result = result + roll($1) + "\n"
            end
            result = result + " " + $6
            bot.say(result)
        elsif text.strip =~ /^:roll help.*$/
            # Display the help.
            bot.say("\n==== Dice Roller (v#{version}) HELP ====\n':roll d6', ':roll 3d6', and ':roll 1d20+1' all work as expected.\n':roll v3d6' is verbose.\n':roll 3d6x6' rolls six sets of 3d6 results.\nEven ':roll v 10d3 +2 x8' works.")
        elsif text.strip =~ /^:roll.*$/
            # Huh? Mention help.
            bot.say("Huh? Type ':roll help' for instructions.")
        end
    end
}
bot.on_room_message { |time,text|
  print_line time, "- #{text}"
}
bot.on_subject { |time,nick,subject|
  print_line time, "*** (#{nick}) #{subject}"
}

bot.join(room_and_nick)

Thread.stop

xmpp.close
