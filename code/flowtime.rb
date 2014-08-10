#!/usr/bin/env ruby
##
## Copyright 2007 Matthew Lee Hinman
## matthew [dot] hinman [at] gmail [dot] com
##
## Generate a file to plot pcap traffic flows over time
## To get usage: ./flowtime --help
##

if ARGV.length < 3  or ARGV.to_s =~ /--help/
  STDERR.puts "Usage:"
  STDERR.puts "flowtime [-w #] [-h #] [-g] [--help] <pcapfile> <ipaddr> <outfile_bas>" 
  STDERR.puts "-w specify the width, default: 2000"
  STDERR.puts "-h specify the height, default: 2000"
  STDERR.puts "-g automatically try generate a png (requires 'EasyTimeline' and 'pl' in path)"
  STDERR.puts "<pcapfile> the packet file to generate a graph of"
  STDERR.puts "<ipaddr> source address to generate a graph for, 'all' for all IPs"
  STDERR.puts "<outfile_base> basename for the output file"
  exit(0)
end

$WIDTH = ARGV.to_s =~ /-w\s*(\d+)/i ? $1.to_i : 2000
$HEIGHT = ARGV.to_s =~ /-h\s*(\d+)/i ? $1.to_i : 2000
$autograph = ARGV.to_s =~ /-g/i ? true : false
STDERR.puts "Width  : #{$WIDTH}"
STDERR.puts "Height : #{$HEIGHT}"

$filename = ARGV[ARGV.length-3].to_s
$ipaddr = ARGV[ARGV.length-2].to_s
$outfile = ARGV[ARGV.length-1].to_s
STDERR.puts "Outfile: #{$outfile}.txt"
$stdout = File.new("#{$outfile}.txt","w")
unless File.exist?($filename)
  puts "File: #{$filename} does not exist."
  exit(0)
end

events = []
$start = 0.0
$finish = 0.0

class TimeLine
  attr_reader :stime,:etime,:port,:addr

  def initialize(stime,etime,port,addr)
    @stime = stime
    @etime = etime
    @port = port.to_i
    @addr = addr
  end

end

def time_to_seconds(time)
  newtime = 0
  hour,min,second = time[0,8].split(":")
  newtime += second.to_i
  newtime += min.to_i * 60
  newtime += hour.to_i * 60 * 60
  newtime = newtime.to_s
  newtime = newtime + time[8,7]
  return newtime.to_f
end

STDERR.print "Generating flow data..."
if $ipaddr =~ /all/i
  argus_output = `argus -mJRU 128 -r #{$filename} -w - | racluster -w - -r - | rasort -m stime -L0 -ns stime ltime dport daddr`
else
  argus_output = `argus -mJRU 128 -r #{$filename} -w - | racluster -w - -r - - ip src #{$ipaddr} | rasort -m stime -L0 -ns stime ltime dport daddr`
end
STDERR.puts "done."

STDERR.print "Parsing Argus output..."
argus_output.each_line do |line|
  line.strip!
  data = line.split(/\s+/)
  next unless data[0] =~ /^\d/i
  if data.length < 4
    data[3] = data[2]
    data[2] = 0
  end
  $start = time_to_seconds(data[0]) if $start == 0
  $finish = time_to_seconds(data[1]) if $finish < time_to_seconds(data[1])
  events.unshift(TimeLine.new(data[0],data[1],data[2],data[3]))
end
STDERR.puts "done."

#puts "Start: #{$start}"
#puts "Finish: #{$finish}"

STDERR.print "Generating graph data..."
puts "ImageSize  = width:#{$WIDTH} height:#{$HEIGHT}"
puts "PlotArea   = width:#{$WIDTH-155} height:#{$HEIGHT-50} left:150 bottom:40"
puts "AlignBars  = justify"

puts "Colors ="
puts "  id:http       value:blue        legend:HTTP"
puts "  id:ssl        value:red         legend:SSL"
puts "  id:ssh        value:green       legend:SSH"
puts "  id:ftp        value:magenta     legend:FTP"
puts "  id:telnet     value:orange      legend:Telnet"
puts "  id:smtp       value:coral       legend:SMTP"
puts "  id:dns        value:pink        legend:DNS"
puts "  id:pop3       value:purple      legend:POP3"
puts "  id:bootp      value:kelleygreen legend:BootPS/C"
puts "  id:imap       value:lightpurple legend:IMAP"
puts "  id:netbios    value:claret      legend:netbios "
puts "  id:irc        value:teal        legend:IRC"
puts "  id:noport     value:powderblue  legend:NoPort"
puts "  id:other      value:yellow      legend:Other"
puts "  id:lightgrey  value:gray(0.9)"
puts "  id:darkgrey   value:gray(0.1)"

puts "Period     = from:#{$start} till:#{$finish}"
puts "TimeAxis   = orientation:horizontal"
inc = ($finish - $start) / ($WIDTH / 50)
inc = inc.to_i
inc = 1 if inc < 1
puts "ScaleMajor = increment:#{inc} start:#{$start.ceil} gridcolor:lightgrey"

puts "PlotData="

events.each { |e|
  print "  bar: #{e.addr}-#{e.port} "
  case e.port
  when 0
    print "color:noport "
  when 80
    print "color:http "
  when 443
    print "color:ssl "
  when 22
    print "color:ssh "
  when 23
    print "color:telnet "
  when 21
    print "color:ftp "      
  when 25
    print "color:smtp "
  when 53
    print "color:dns "
  when 67..68
    print "color:bootp "
  when 110
    print "color:pop3 "
  when 137..139
    print "color:netbios "
  when 6666..6669,7000
    print "color:irc "
  else
    print "color:other "
  end
  puts "mark:(line,white) width:7 align:left fontsize:XS"
  puts "  from:#{time_to_seconds(e.stime)}  till:#{time_to_seconds(e.etime)}"
}

puts "Legend = orientation:vertical position:bottom columns:3 columnwidth:140"
STDERR.puts "done."

$defout.close

if $autograph
  STDERR.print "Automatically creating graph..."
  system("EasyTimeline -b -i #{$outfile}.txt 2>&1 > /dev/null")
  STDERR.puts "done. (returned #{$?})"
end
