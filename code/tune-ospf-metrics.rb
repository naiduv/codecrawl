#!/usr/bin/env ruby
#

require "rubygems"
require "icmp4em"
require "syslog"

OSPF_COST_MAX = 32768

class Stats
  attr_accessor :count
  attr_accessor :latency

  def initialize
    @count = 0
    @latency = 0.0
    @failure = false
  end

  def <<(latency)
    @latency += latency
    @count += 1
  end

  def avg
    return @latency / @count
  end

  def fail!
    @failure = true
  end

  def failure?
    return @failure
  end

end

class Neighbor < Struct.new(:router_id, :interface);  end

pingoptions = {
  :interval => 1,
  :timeout => 10,
}

Syslog.open("tune-ospf-metrics", Syslog::LOG_PID)
neighbor_stats = Hash.new { |h,k| h[k] = Stats.new }

EM.run do
  %x{vtysh -c 'show ip ospf neighbor'}.split("\n").each do |line|
    next unless line =~ /^ *[0-9]/
    router_id, priority, state, deadtime, address, interface, other = line.split
    #next if interface =~ /^eth[0-9]:/
    next unless interface =~ /^tap[0-9]+:/

    total = 0.0
    count = 10
    timeout = 30.0
    vpn_if = interface.split(":")[0]

    neighbor = Neighbor.new
    neighbor.router_id = router_id
    neighbor.interface = vpn_if
    
    pinger = ICMP4EM::ICMPv4.new(address, pingoptions)
    pinger.on_success do |host, seq, latency|
      neighbor_stats[neighbor] << latency
      if neighbor_stats[neighbor].count == count
        pinger.stop
        if neighbor_stats.select {|k,v| v.count != count }.length == 0
          # All interfaces are done.
          EventMachine::stop_event_loop
        end
      end
    end
    pinger.on_expire do |host, seq, exception|
      # Ping timed out, set this neighbor to failure.
      neighbor_stats[neighbor].fail!
      puts exception.inspect
      pinger.stop
    end
    pinger.schedule
  end
end

IO.popen("vtysh > /dev/null", "w") do |quagga|
  quagga.puts "conf t"
  neighbor_stats.each do |neighbor, stats|
    quagga.puts "interface #{neighbor.interface}"
    if stats.failure?
      cost = OSPF_COST_MAX
    else
      #$stderr.puts "#{neighbor.interface}: #{stats.failure?} / #{stats.avg}"
      cost = (stats.avg * 10).to_i
    end
    Syslog.info "Setting #{neighbor.interface}/#{neighbor.router_id} cost to #{cost}"
    quagga.puts "  ip ospf cost #{cost}"
  end
end
