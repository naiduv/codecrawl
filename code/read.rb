require 'rinda/ring'

DRb.start_service

ts = Rinda::RingFinger.primary

result = ts.read [:message, nil], 0

puts "[0]: #{result[0]}"
puts "[1]: #{result[1]}"
