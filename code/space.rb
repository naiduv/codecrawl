##########################################################################
### CMSC330 Project 2: Multi-threaded Space Simulation                 ###
### Source code: space.rb                                              ###
### Description: Multi-threaded Ruby program simulating space travel   ###
### Student Name: ??                                                   ###
##########################################################################

require "monitor"

Thread.abort_on_exception = true   # to avoid hiding errors in threads 

#------------------------------------
# Global Variables
        
$headerPorts = "=== Starports ==="
$headerShips = "=== Starships ==="
$headerTraveler = "=== Travelers ==="
$headerOutput = "=== Output ==="

$simOut = []            # simulation output

$starport = []
$starship = []
$traveler = []

#----------------------------------------------------------------
# Starport 
#----------------------------------------------------------------

class Starport
    def initialize (name,size)
        @name = name
        @size = size
        @ships = []
        @travelers = []
    end
    
    def to_s
        @name
    end

    def size
        @size
    end
	
    def arrive(person)
        @travelers.push(person)
    end
end

#------------------------------------------------------------------
# find_name(name) - find port based on name

def find_name(arr, name)
    arr.each { |p| return p if (p.to_s == name) }
    puts "Error: find_name cannot find #{name}"
        $stdout.flush
end

#------------------------------------------------------------------
# next_port(c) - find port after current port, wrapping around

def next_port(current_port)
    port_idx = $starport.index(current_port)
    if !port_idx
        puts "Error: next_port missing #{current_port}"
        $stdout.flush
        return  $starport.first
    end
    port_idx += 1
    port_idx = 0 if (port_idx >= $starport.length)
    $starport[port_idx]
end

#----------------------------------------------------------------
# Starship 
#----------------------------------------------------------------

class Starship 
    def initialize (name,size)
        @name = name
		@size = size
        @passengers = []
    end
	
    def size
        @size
    end
	    
    def to_s
        @name
    end
end         


#----------------------------------------------------------------
# Traveler 
#----------------------------------------------------------------

class Traveler
    def initialize(name, itinerary)
        @name = name
        @itinerary = itinerary
    end

    def to_s
        @name
    end
	
    def itinerary
        @itinerary
    end
end

#------------------------------------------------------------------
# read command line and decide on display(), verify() or simulate()

def readParams(fname)
    begin
        f = File.open(fname)
    rescue Exception => e
        puts e
        $stdout.flush
        exit(1)
    end

    section = nil
    f.each_line{|line|

        line.chomp!
        line.strip!
        if line == "" || line =~ /^%/
            # skip blank lines & lines beginning with %

        elsif line == $headerPorts || line == $headerShips ||
        line == $headerTraveler || line == $headerOutput
            section = line

        elsif section == $headerPorts
            parts = line.split(' ')
            name = parts[0]
            size = parts[1].to_i
            $starport.push(Starport.new(name,size))
                
        elsif section == $headerShips
            parts = line.split(' ')
            name = parts[0]
			size = parts[1].to_i
            $starship.push(Starship.new(name,size))

        elsif section == $headerTraveler
            parts = line.split(' ')
            name = parts.shift
            itinerary = []
            parts.each { |p| itinerary.push(find_name($starport,p)) }
            person = Traveler.new(name,itinerary)
            $traveler.push(person)
            find_name($starport,parts.first).arrive(person)

        elsif section == $headerOutput
            $simOut.push(line)

        else
            puts "ERROR: simFile format error at #{line}"
            $stdout.flush
            exit(1)
        end
    }
end

#------------------------------------------------------------------
# 

def printParams()
    
    puts $headerPorts
    $starport.each { |s| puts "#{s} #{s.size}" }
    
    puts $headerShips 
    $starship.each { |s| puts "#{s} #{s.size}" }
    
    puts $headerTraveler 
    $traveler.each { |p| print "#{p} "
                               p.itinerary.each { |s| print "#{s} " } 
                               puts }

    puts $headerOutput
    $stdout.flush
end

#----------------------------------------------------------------
# Simulation Display
#----------------------------------------------------------------

def array_to_s(arr)
    out = []
    arr.each { |p| out.push(p.to_s) }
    out.sort!
    str = ""
    out.each { |p| str = str << p << " " }
    str
end

def pad_s_to_n(s, n)
    str = "" << s
    (n - str.length).times { str = str << " " }
    str
end

def ship_to_s(ship)
    str = pad_s_to_n(ship.to_s,12) << " " << array_to_s(ship.passengers)
    str
end

def display_state()
    puts "----------------------------------------"
    $starport.each { |port|
        puts "#{pad_s_to_n(port.to_s,13)} #{array_to_s(port.travelers)}"
        out = []
        port.ships.each { |ship| out.push("  " + (ship_to_s(ship))) }
        out.sort.each { |line| puts line }
    }
    puts "----------------------------------------"
end


#------------------------------------------------------------------
# display - print state of space simulation

def display()
    display_state()
    $simOut.each {|o|
        puts o
        if o =~ /(\w+) (docking at|departing from) (\w+)/
            ship = find_name($starship,$1); 
            action = $2;
            port = find_name($starport,$3); 
            if (action == "docking at")
                port.ships.push(ship)
            else
                port.ships.delete(ship)
            end
                
        elsif o =~ /(\w+) (board|depart)ing (\w+) at (\w+)/
            person = find_name($traveler,$1); 
            action = $2;
            ship = find_name($starship,$3); 
            port = find_name($starport,$4); 
            if (action == "board")
                ship.passengers.push(person)
                port.travelers.delete(person)
            else 
                ship.passengers.delete(person)
                port.travelers.push(person)
            end
        else
            puts "% ERROR Illegal output #{o}"
        end
        display_state()
    }
end

#------------------------------------------------------------------
# verify - check legality of simulation output

def verify
    validSim = true
    $simOut.each {|o|
        if o =~ /(\w+) (docking at|departing from) (\w+)/
            ship = find_name($starship,$1); 
            action = $2;
            port = find_name($starport,$3); 
            if (action == "docking at")
            else
            end
                
        elsif o =~ /(\w+) (board|depart)ing (\w+) at (\w+)/
            person = find_name($traveler,$1); 
            action = $2;
            ship = find_name($starship,$3); 
            port = find_name($starport,$4); 

            if (action == "board")
            else 
            end
        else
            puts "% ERROR Illegal output #{o}"
        end
    }
    return validSim
end

#------------------------------------------------------------------
# simulate - perform multithreaded space simulation

def simulate()

end

#------------------------------------------------------------------
# main - simulation driver

def main
    if ARGV.length != 2
        puts "Usage: ruby space.rb [simulate|verify|display] <simFileName>"
        exit(1)
    end
    
    # list command line parameters
    cmd = "% ruby space.rb "
    ARGV.each { |a| cmd << a << " " }
    puts cmd
    
    readParams(ARGV[1])
  
    if ARGV[0] == "verify"
        result = verify()
        if result
            puts "VALID"
        else
            puts "INVALID"
            exit(1)
        end

    elsif ARGV[0] == "simulate"
        printParams()
        simulate()

    elsif ARGV[0] == "display"
        display()

    else
        puts "Usage: space [simulate|verify|display] <simFileName>"
        exit(1)
    end
    exit(0)
end

main

