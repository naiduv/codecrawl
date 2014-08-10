#!/usr/bin/env ruby

# :title: MapPoint Object Testing Script
# This script runs the MapPoint object through some simple tests
# 
# * Point instantiation
# * Point inspection
# * Instantiated point configuration
# * ToString method test
# * Object conversion to radians
# * Test boolean in_radians method
# * Test distance functions global point set
# * Test distance functions local point set
require 'mappoint'

puts "\n\n\n\nMapPoint Test: A test of the MapPoint object class\n\n"

puts "Create two new points\n"
p1 = MapPoint.new()
p2 = MapPoint.new(37.429282,-122.167175)
puts "Done...\n\n"

puts "Our objects by inspection\n"
puts "Point 1:" + p1.inspect
puts "Point 2" + p2.inspect
puts "Done...\n\n"

puts "Configure point 1 - add lat/lon\n"
p1.lat = 51.513403
p1.lon = -0.114976
puts "Done...\n\n"

puts "Our objects\n"
puts "Point 1:" + p1.to_s
puts "Point 2:" + p2.to_s
puts "Done...\n\n"

puts "Are these in radians?\n"
puts "Point 1: " + p1.in_radians.to_s
puts "Point 2: " + p2.in_radians.to_s
puts "Done...\n\n"

puts "Convert to radians\n"
p1.convert_to_radians
p2.convert_to_radians
puts "Our modified objects\n"
puts "Point 1:" + p1.to_s
puts "Point 2:" + p2.to_s
puts "Done...\n\n"

puts "Are these in radians now?\n"
puts "Point 1: " + p1.in_radians.to_s
puts "Point 2: " + p2.in_radians.to_s
puts "Done...\n\n"

puts "How far apart are these points? (Ans:8646.604km)\n"
d=p1.distance(p2)
puts "p1 says: "+d.to_s
d=p2.distance(p1)
puts "p2 says: "+d.to_s

puts "Making a few more global points...\n"
p3 = MapPoint.new(48.463275,-123.311706) # Univ. of Victoria
p4 = MapPoint.new(27.77052,-82.662678) # St.Petersburg, Russia
p5 = MapPoint.new(-27.457616,153.055515) # GSB, QUT, Brisbane, Australia
p4.convert_to_radians #convert St. Petersburg
puts "\nThese results may vary from ans derived from different radius\n"
d=p1.distance(p5)
puts "Distance p1 to p5 (Ans:~16530km): " + d.to_s
d=p2.distance(p4)
puts "Distance p2 to p4 (Ans:~3823km): " + d.to_s
d=p3.distance(p5)
puts "Distance p3 to p5 (Ans:~11810km): " + d.to_s
d=p4.distance(p5)
puts "Distance p4 to p5 (Ans:~14580km): " + d.to_s
d=p5.distance(p5)
puts "Distance p5 to p5 (Ans: 0km): " + d.to_s
d=p1.distance(p4)
puts "Distance p1 to p4 (Ans:~7132km): " + d.to_s
d=p5.distance(p3)
puts "Distance p5 to p3 (Ans:~11810km): " + d.to_s
d=p1.distance(p3)
puts "Distance p1 to p3 (Ans:~7661km): " + d.to_s
d=p5.distance(p2)
puts "Distance p5 to p2 (Ans:~11400km): " + d.to_s

puts "\nMaking a few more local points (Stanford and Cupertino)...\n"
p6 = MapPoint.new(37.331932,-122.029615) # Apple
p7 = MapPoint.new(37.427572,-122.170241) # Main Quad, Stanford, CA
p8 = MapPoint.new(37.428635,-122.165871) # Landau Economics, Stanford, CA
d=p2.distance(p6)
puts "Distance p2 to p6 (VentureLab to Apple): " + d.to_s
d=p6.distance(p7)
puts "Distance p6 to p7 (Apple to Main Quad): " + d.to_s
d=p7.distance(p8)
puts "Distance p7 to p8 (Main Quad to Landau): " + d.to_s
d=p8.distance(p2)
puts "Distance p8 to p2 (Landau to GSB): " + d.to_s
