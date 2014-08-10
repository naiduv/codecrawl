#!C:\ruby\bin

#This program demonstrates the Ruby Hash function
#author: Lucas Downard - N00159998

puts "hello world!"
puts "Welcome to my first ruby program! (Please press enter to continue}"
gets.chomp
puts ""
##########################################
#declairs a new hash variable h
##########################################
puts "This first section outputs data from a hash assigned in a normal fashion (press enter)"
gets.chomp

h = Hash.new("")

#assigns h some values
h[:bird]="canary"
h[:fish]="bass"
h[:soup]="noodle"

#output those values
puts h[:bird]
puts h[:fish]
puts h[:soup]

##########################################
#Build a new hash that has a default value for unassigned hash locations
##########################################
puts ""
puts "This section assigns a default value, of carrots, assigns a key of vegetable,
and then outputs vegetable and two unassigned values to test the default (press enter)"
gets.chomp
i=Hash.new("")

i.default << "carrots" 
#I guess the << is another assignedment variable?
#What does >> do then?  Tried and it gave undefined method
i[:vegetable]  = "lettuce"

puts i[:vegetable]
puts i[:unassigned]
puts i[:other]
##########################################
#Try one more thing....
##########################################
puts ""
puts "This last section tests the differences between using = and << (press enter)"
gets.chomp
g=Hash.new("")

puts "using '=' for assignment"
g[:furnature] = "table"

puts g[:furnature]
puts g[:unassigned]

j=Hash.new("")
puts "using '<<' for assignment"
j[:furnature] << "table"
j[:flooring]<<"tile"

puts j[:furnature]
puts j[:unassigned]
puts j[:flooring]