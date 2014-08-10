#!/usr/bin/ruby

puts "\n===================== COPY BY REFERENCE ==================="
myString = "Steve" + " " + "Lit"
myCopy = myString
myString << "t"
puts "myString: " + myString
puts "myCopy  : " + myCopy

puts "\n===================== COPY BY VALUE ==================="
myCopy2 = String.new(myString)
myString[-1,1] = ""

puts "myString: " + myString
puts "myCopy  : " + myCopy
puts "myCopy2 : " + myCopy2

puts "\n===================== MIDDLE SUBSTITUTION ==================="
myString = "Steve was here"
puts myString
string2swap = "was"
start_ss = myString.index(string2swap)
myString[start_ss, string2swap.length()] = 'is'
puts myString

puts "\n===================== STRING MULTIPLICATION ==================="
myString = "Ruby " * 4
puts myString

puts "\n===================== RUBY # operator ==================="
mystring = "There are %6d people in %s" % [1500, "the Grand Ballroom"]
puts mystring
puts "Don't forget you also have printf() and sprintf()"

puts "\n===================== STRING SPLIT ==================="
myString = "Steve was here and now is gone"
myArray = myString.split(/\s+/)
i = 0
myArray.each{|element| printf("%3d: %s\n", i, element); i+=1}

puts "\n===================== ARRAY JOIN ==================="
myString = myArray.join("_")
puts myString
puts "\n========================================"
