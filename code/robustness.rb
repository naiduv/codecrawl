#! /usr/bin/ruby
#
#   2
#  / \
# 1-5-4
#  \ / \
#   3---6
#
# 1: dga
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
		puts "./srouted -i #{id} -c #{file} -a 1 -n 10 &> /dev/null &"
	  system("./srouted -i #{id} -c #{file} -a 1 -n 10 &> /dev/null &")
		return $?.pid
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
		return $?.pid
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

def usertable_at2(rdaemon)
	rdaemon.send("USERTABLE")
	data=rdaemon.recv_data_from_rdaemon(1)

	if(!rdaemon.checksize(data,4))
		return false
	end

	responsehash = rdaemon.createuserhash(data)
	if(!rdaemon.checkuserhash(responsehash, "gnychis", 4, 2))
		return false
	elsif(!rdaemon.checkuserhash(responsehash, "vyass", 1, 2))
		return false
	elsif(!rdaemon.checkuserhash(responsehash, "dga", 1, 1))
		return false
	elsif(!rdaemon.checkuserhash(responsehash, "srini", 4, 1))
		return false
	end

	return true  # you must have survived!
end
		
def usertable_at2k1(rdaemon)
	rdaemon.send("USERTABLE")
	data=rdaemon.recv_data_from_rdaemon(1)

	if(!rdaemon.checksize(data,3))
		return false
	end

	responsehash = rdaemon.createuserhash(data)
	if(!rdaemon.checkuserhash(responsehash, "gnychis", 4, 2))
		return false
	elsif(!rdaemon.checkuserhash(responsehash, "vyass", 4, 2))
		return false
	elsif(!rdaemon.checkuserhash(responsehash, "srini", 4, 1))
		return false
	end

	return true  # you must have survived!
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
    exit(0) if !passed
end

#### WRITE CONFIG FILE
#
# YOU mAY EDIT THE PORT NUMBERS HERE ONLY
# (to avoid port collisions while testing on andrew)
write_config()

begin

# Spawn the daemons.  This runs command lines of
# ./srouted -i ## -c cprnode##.conf  (where ## == 1 through 4)
# Let everything settle
puts "Letting everything settle."
sleep(2)


################### MALICIOUS DAVE OVERFLOW ##############################
# Lets turn Dave malicious now and see if he disconnects the student
# by crashing the server
	tn = test_name("MALICIOUS DAVE OVERFLOW")
	spawn_daemon("final_grading1.conf", 1)				# Spawn daemon
	sleep(2)
	spawn_server("final_grading1.conf", 1)				# Spawn server
	sleep(2)
	irc1 = conn_server("final_grading1.conf", 1)	# Connect to servers
	irc7 = conn_server("final_grading1.conf", 1)
	irc1.send_nick("dga")													# Set up "dga" and "student" users
  irc1.send_user("please give me :The MOTD")
	irc7.send_nick("student")
	irc7.send_user("please give me :The MOTD")
	irc1.ignore_reply()
	irc7.ignore_reply()
	irc1.send_junk(15000)														# Have "dga" send some junk
	sleep(2) # lets let it digest
	# Lets make sure the server is alive by student messaging himself
	irc7.send_privmsg("student", "I'm alive")
	eval_test(tn, nil, nil, irc7.checkmsg("student", "student", "I'm alive"))
	system("killall srouted")
	system("killall sircd")

#################### LOTS OF CLIENTS #############################
# Lets test some scalability
	tn = test_name("LOTS OF CLIENTS")
	spawn_daemon("final_grading1.conf", 1)				# Spawn daemon
	sleep(2)
	spawn_server("final_grading1.conf", 1)				# Spawn server
	sleep(5)
	
	clients=0
	max=20
	carray = Array.new
	puts "Connecting #{max} clients, please wait..."
	while(clients < max)
		carray[clients] = conn_server("final_grading1.conf", 1)
		clients = clients + 1
		puts "Connected #{clients}"
	end

	carray[max-1].send_nick("srini")
	carray[max-1].send_user("please give me :The MOTD")
	carray[max-1].ignore_reply()
	carray[max-1].send_privmsg("srini", "I'm alive")
	eval_test(tn, nil, nil, carray[max-1].checkmsg("srini", "srini", "I'm alive"))
		
	system("killall srouted")
	system("killall sircd")


################### KILLING SERVERS AND DAEMONS ##########################
# Lets kill some servers and daemons and watch the tables
	dpid1=spawn_daemon("final_grading1.conf", 1)
	dpid1 = dpid1 + 1  # can't figure out how to get exact pid yet
	spawn_daemon("final_grading2.conf", 2)
	spawn_daemon("final_grading3.conf", 3)
	spawn_daemon("final_grading4.conf", 4)
	spawn_daemon("final_grading5.conf", 5)
	spawn_daemon("final_grading6.conf", 6)

	puts "Sleeping for 2 seconds to let the IRC servers finish starting..."
	sleep(2)

	puts "Connecting to the daemons..."
	# Now connect a TCP socket to the daemons
	rdaemon1 = conn_daemon("final_grading1.conf", 1)
	rdaemon2 = conn_daemon("final_grading2.conf", 2)
	rdaemon3 = conn_daemon("final_grading3.conf", 3)
	rdaemon4 = conn_daemon("final_grading4.conf", 4)
	rdaemon5 = conn_daemon("final_grading5.conf", 5)
	rdaemon6 = conn_daemon("final_grading6.conf", 6)

	puts "Sleeping for 5 seconds to let everything settle."
	sleep(5)

	# Setting up users for the test
	rdaemon1.adduser("dga")
	rdaemon4.adduser("srini")
	rdaemon5.adduser("vyass")
	rdaemon6.adduser("gnychis")
	rdaemon1.ignore_reply()
	rdaemon4.ignore_reply()
	rdaemon5.ignore_reply()
	rdaemon6.ignore_reply()
	
	tn = test_name("USERTABLE @ Node 2")
	eval_test(tn, nil, nil, usertable_at2(rdaemon2))

	# Take down node 1 and check the user table
	tn = test_name("USERTABLE @ Node 2 **AFTER NODE 1 DOWN**")
	system("kill -9 #{dpid1}") 
	puts "Allowing convergance for 10 seconds"
	sleep(20)
	eval_test(tn, nil, nil, usertable_at2k1(rdaemon2))

	# Now lets bring it back up
	dpid1=spawn_daemon("final_grading1.conf", 1)
	sleep(2)
	rdaemon1 = conn_daemon("final_grading1.conf", 1)
	rdaemon1.adduser("dga")
	sleep(20)
	tn = test_name("USERTABLE @ Node 2 **BACK UP**")
	eval_test(tn, nil, nil, usertable_at2(rdaemon2))


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
