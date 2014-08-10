require 'rinda/ring'
require 'rinda/tuplespace'

DRb.start_service

ts = Rinda::TupleSpace.new
Rinda::RingServer.new ts

puts 'The blackboard is started...'

DRb.thread.join
