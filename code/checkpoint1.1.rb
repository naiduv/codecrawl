#! /usr/bin/env ruby
#  This script is worth NO points. We just hand it to you for testing your server's forwarding-related functionalities (using our rdaemon binary).
#   2
#  / \
# 1-5-4
#  \ / \
#   3---6
#
# 1: dga
# 3: dwen
# 4: srini
# 5: vyass
# 6: gnychis
#

## SKELETON STOLEN FROM http://www.bigbold.com/snippets/posts/show/1785
require 'socket'
require 'rdaemon'
require 'irc'
#$SAFE = 1

$total_points = 0
$total_tests = 0

##
# The main program.  Tests are listed below this point.  All tests
# should call the "result" function to report if they pass or fail.
##

def write_config()
    File.open("final_grading1.conf", "w") { |afile|
	afile.puts "1 127.0.0.1 34100 34101 34102"
	afile.puts "2 127.0.0.1 34103 34104 34105"
	afile.puts "3 127.0.0.1 34106 34107 34108"
	afile.puts "5 127.0.0.1 34112 34113 34114"
    }

    File.open("final_grading2.conf", "w") { |afile|
	afile.puts "1 127.0.0.1 34100 34101 34102"
	afile.puts "2 127.0.0.1 34103 34104 34105"
	afile.puts "4 127.0.0.1 34109 34110 34111"
    }

    File.open("final_grading3.conf", "w") { |afile|
	afile.puts "1 127.0.0.1 34100 34101 34102"
	afile.puts "3 127.0.0.1 34106 34107 34108"
	afile.puts "4 127.0.0.1 34109 34110 34111"
	afile.puts "6 127.0.0.1 34115 34116 34117"
    }

    File.open("final_grading4.conf", "w") { |afile|
	afile.puts "4 127.0.0.1 34109 34110 34111"
	afile.puts "2 127.0.0.1 34103 34104 34105"
	afile.puts "3 127.0.0.1 34106 34107 34108"
	afile.puts "5 127.0.0.1 34112 34113 34114"
	afile.puts "6 127.0.0.1 34115 34116 34117"
    }
    
		File.open("final_grading5.conf", "w") { |afile|
	afile.puts "1 127.0.0.1 34100 34101 34102"
	afile.puts "4 127.0.0.1 34109 34110 34111"
	afile.puts "5 127.0.0.1 34112 34113 34114"
    }
    
		File.open("final_grading6.conf", "w") { |afile|
	afile.puts "4 127.0.0.1 34109 34110 34111"
	afile.puts "3 127.0.0.1 34106 34107 34108"
	afile.puts "6 127.0.0.1 34115 34116 34117"
    }
end

# Go through the config file, looking for the "id" passed,
# and spawn it
def spawn_daemon(file,id)
afile = File.open(file, "r")
afile.each_line do |line|
	line.chomp!
	(nodeid, ip, lport, dport, sport)=line.split
	if(nodeid.to_i == id)  # dont forget to convert to int
		puts "./srouted -i #{id} -c #{file} -a 1 &"
	  system("./srouted -i #{id} -c #{file} -a 1 &> /dev/null &")
		return 1 
	end
end
end

def conn_daemon(file,id)
afile = File.open(file, "r")
afile.each_line do |line|
	line.chomp!
	(nodeid, ip, lport, dport, sport)=line.split
	if(nodeid.to_i == id)  # dont forget to convert to int
		rdaemon = RDAEMON.new(ip, dport.to_i, '', '')
		rdaemon.connect()
		return rdaemon 
	end
end
end

def spawn_server(config,id)
afile = File.open(config, "r")
afile.each_line do |line|
	line.chomp!
	(nodeid, ip, lport, dport, sport)=line.split
	if(nodeid.to_i == id)  # dont forget to convert to int
		puts "./sircd #{id} #{config} &> /dev/null &"
		system("./sircd #{id} #{config} &> /dev/null &")
		return 1 
	end
end
end

def conn_server(config,id)
afile = File.open(config, "r")
afile.each_line do |line|
	line.chomp!
	(nodeid, ip, lport, dport, sport)=line.split
	if(nodeid.to_i == id)  # dont forget to convert to int
		server = IRC.new(ip, sport.to_i, '', '')
		server.connect()
		return server
	end
end
end
		
def test_name(n)
    puts "////// #{n} \\\\\\\\\\\\"
    return n
end

def result(n, passed_exp, failed_exp, passed, points)
    explanation = nil
	$total_tests += 1
    if (passed)
	puts "(+) #{n} passed"
	$total_points += points
	explanation = passed_exp
    else
	puts "(-) #{n} failed"
	explanation = failed_exp
    end

    if (explanation)
	puts ": #{explanation}"
    else
	puts ""
    end
end

def eval_test(n, passed_exp, failed_exp, passed, points = 1)
    result(n, passed_exp, failed_exp, passed, points)
#    exit(0) if !passed
end

#### WRITE CONFIG FILE
#
# YOU mAY EDIT THE PORT NUMBERS HERE ONLY
# (to avoid port collisions while testing on andrew)
write_config()

begin

# Spawn the daemons.  This runs command lines of
# ./srouted -i ## -c cprnode##.conf  (where ## == 1 through 4)
spawn_daemon("final_grading1.conf", 1)
spawn_daemon("final_grading2.conf", 2)
spawn_daemon("final_grading3.conf", 3)
spawn_daemon("final_grading4.conf", 4)
spawn_daemon("final_grading5.conf", 5)
spawn_daemon("final_grading6.conf", 6)

puts "Letting the daemons settle."
sleep(2)

spawn_server("final_grading1.conf", 1)
spawn_server("final_grading2.conf", 2)
spawn_server("final_grading3.conf", 3)
spawn_server("final_grading4.conf", 4)
spawn_server("final_grading5.conf", 5)
spawn_server("final_grading6.conf", 6)

# Let the servers settle
puts "Letting the servers settle."
sleep(2)


irc1 = conn_server("final_grading1.conf", 1)
irc2 = conn_server("final_grading2.conf", 2)
irc3 = conn_server("final_grading3.conf", 3)
irc4 = conn_server("final_grading4.conf", 4)
irc5 = conn_server("final_grading5.conf", 5)
irc6 = conn_server("final_grading6.conf", 6)

# Let everything settle
puts "Letting everything settle."
sleep(2)


################## USER PRIVMSG TEST #################
#
	irc1.send_nick("dga")
  irc1.send_user("please give me :The MOTD")
	irc3.send_nick("dwen")
  irc3.send_user("please give me :The MOTD")
	irc4.send_nick("srini")
  irc4.send_user("please give me :The MOTD")
	irc5.send_nick("vyass")
  irc5.send_user("please give me :The MOTD")
	irc6.send_nick("gnychis")
  irc6.send_user("please give me :The MOTD")
	irc1.ignore_reply()
	irc3.ignore_reply()
	irc4.ignore_reply()
	irc5.ignore_reply()
	irc6.ignore_reply()

	puts "Letting user routing tables settle"
	sleep(5)

	tn = test_name("dga --PRIVMSG--> dwen")
	irc1.send_privmsg("dwen", "Hey Dan, it's Dave")
	eval_test(tn, nil, nil, irc3.checkmsg("dga", "dwen", "Hey Dan, it's Dave"))
	
	tn = test_name("dwen --PRIVMSG--> dga")
	irc3.send_privmsg("dga", "Hey Dave, go climb a rock")
	eval_test(tn, nil, nil, irc1.checkmsg("dwen", "dga", "Hey Dave, go climb a rock"))
	
	tn = test_name("dwen --PRIVMSG--> srini")
	irc3.send_privmsg("srini", "Hey Srini, our students are failing")
	eval_test(tn, nil, nil, irc4.checkmsg("dwen", "srini", "Hey Srini, our students are failing"))
	
	tn = test_name("dga --PRIVMSG--> gnychis")
	irc1.send_privmsg("gnychis", "Hey George, Vyas says hi")
	eval_test(tn, nil, nil, irc6.checkmsg("dga", "gnychis", "Hey George, Vyas says hi"))
	
	tn = test_name("gnychis --PRIVMSG--> vyass")
	irc6.send_privmsg("vyass", "Hey Vyas, long time no talk")
	eval_test(tn, nil, nil, irc5.checkmsg("gnychis", "vyass", "Hey Vyas, long time no talk"))
	
	tn = test_name("vyass --PRIVMSG--> gnychis")
	irc5.send_privmsg("gnychis", "Hey George, I am /ignore'ing Dan")
	eval_test(tn, nil, nil, irc6.checkmsg("vyass", "gnychis", "Hey George, I am /ignore'ing Dan"))
	
	tn = test_name("vyass --PRIVMSG--> dga")
	irc5.send_privmsg("dga", "Dave, tell Dan he is on /ignore")
	eval_test(tn, nil, nil, irc1.checkmsg("vyass", "dga", "Dave, tell Dan he is on /ignore"))
	

rescue Interrupt
rescue Exception => detail
    puts detail.message()
    print detail.backtrace.join("\n")
ensure
#    rdaemon.disconnect()
		system("killall srouted")
		system("killall sircd")
		puts "\nTests passed: #{$total_points} / #{$total_tests}\n"
end
