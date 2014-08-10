# CIS 115
# Deidre Massingale
# March 28, 2010
# Week 12 (Grocery List)

puts 'Please enter 10 items into your Grocery List!'  # Displays string
lists = []  # Gathers information from user into an array

 while true  # Start while true loop
   
STDOUT.flush  # Allows ruby to work with SciTE
list = gets.chomp  # Gets Value 
  
  if list == ''  # If statement with condition
 puts list  # Tells it to put list

lists [0]  # Marks item place in array
lists [1]  # Marks item place in array
lists [2]  # Marks item place in array
lists [3]  # Marks item place in array
lists [4]  # Marks item place in array
lists [5]  # Marks item place in array
lists [6]  # Marks item place in array
lists [7]  # Marks item place in array
lists [8]  # Marks item place in array
lists [9]  # Marks item place in array
break  # Break while true statement
end  # Ends if statement
lists.push list  # Sets for array to list items in order entered
end  # Ends while true statement

puts 'You entered ' + lists.length.to_s + ' Items to your list!'  # Displays length of array into string

puts  # Puts a space

puts 'How do you want your list displayed!'  # Displays string

while true  # Starts a while true loop
  
puts 'ABC order(O), reversed order(R), ABC reversed order(S), item number(1N) or multiple numbers(2N, 5N, 7N)!'  # Displays string
STDOUT.flush  # Allows ruby to work with SciTE
display = gets.chomp.downcase  # Gets Value in lowercase

puts  # Puts a space

if display == 'o'   # If statement with condition
puts 'Here is your list in ABC order:' # Displays string

puts  # Puts a space

puts lists.sort  # Puts array list in ABC order
end  # Ends if statement

if display == 'r'   # If statement with condition
  puts 'Here is your list in reverse order:'  # Displays string
  
  puts  # Puts a space
  
  puts lists.reverse  # Puts array list in reverse order
end  # Ends if statement

if display == 's'  # If statement with condition
  puts 'Here is your list in reversed ABC order:'  # Displays string
  
  puts  # Puts a space
  
  puts lists.sort.reverse  # Puts array list in ABC order then reverses it
end  # Ends if statement

if display == '1n'  # If statement with condition
  puts 'Enter the item number you want to view(1-10)!'  # Displays string
  STDOUT.flush  # Allows ruby to work with SciTE
  num = gets.chomp.to_i  # Gets num as an integer
  
  puts  # Puts a space
  
  puts 'The item you choose to view is: ' + lists [num - 1]  # Displays item previous to number entered into string 
end  # Ends if statement

if display == '2n'  # If statement with condition
  puts 'Enter the 2 item numbers you want to view (1-10)!'  # Displays string
  STDOUT.flush  # Allows ruby to work with SciTE
  val1 = gets.chomp.to_i  # Gets val as an integer
  STDOUT.flush  # Allows ruby to work with SciTE
  val2 = gets.chomp.to_i  # Gets val as an integer
  
  puts  # Puts a space
  
  print 'The items you choose to view are: ' + lists [val1 - 1]  # Displays item previous to number entered into string
  puts ' and ' + lists [ val2 - 1]  # Displays item previous to number entered into string
end  # Ends if statement

if display == '5n'  # If statement with condition
  puts 'Enter the 5 item numbers you want to view (1-10)!'  # Displays string
  STDOUT.flush  # Allows ruby to work with SciTE
  val1 = gets.chomp.to_i  # Gets val as an integer
  STDOUT.flush  # Allows ruby to work with SciTE
  val2 = gets.chomp.to_i  # Gets val as an integer
  STDOUT.flush  # Allows ruby to work with SciTE
  val3 = gets.chomp.to_i  # Gets val as an integer
  STDOUT.flush  # Allows ruby to work with SciTE
  val4 = gets.chomp.to_i  # Gets val as an integer
  STDOUT.flush  # Allows ruby to work with SciTE
  val5 = gets.chomp.to_i  # Gets val as an integer
  
  puts  # Puts a space
  
  print 'The 5 items you chose to view are: ' + lists [val1 - 1]  # Displays item previous to number entered into string
  puts ', ' + lists [val2 - 1] + ', ' + lists [val3 - 1] + ', ' + lists [val4 - 1] + ' and ' + lists [val5 - 1]  # Displays item previous to number entered into string
end  # Ends if statement

if display == '7n'  # If statement with condition
  puts 'Enter the 7 item numbers you want to view (1-10)!'  # Displays string
  STDOUT.flush  # Allows ruby to work with SciTE
  val1 = gets.chomp.to_i  # Gets val as an integer
  STDOUT.flush  # Allows ruby to work with SciTE
  val2 = gets.chomp.to_i  # Gets val as an integer
  STDOUT.flush  # Allows ruby to work with SciTE
  val3 = gets.chomp.to_i  # Gets val as an integer
  STDOUT.flush  # Allows ruby to work with SciTE
  val4 = gets.chomp.to_i  # Gets val as an integer
  STDOUT.flush  # Allows ruby to work with SciTE
  val5 = gets.chomp.to_i  # Gets val as an integer
  STDOUT.flush  # Allows ruby to work with SciTE
  val6 = gets.chomp.to_i  # Gets val as an integer
  STDOUT.flush  # Allows ruby to work with SciTE
  val7 = gets.chomp.to_i  # Gets val as an integer
  
  puts  # Puts a space
  
  print 'The 7 items you chose to view are: ' + lists [val1 - 1]  # Displays item previous to number entered into string
  puts ', ' + lists [val2 - 1] + ', ' + lists [val3 - 1] + ', ' + lists [val4 - 1] +   # Displays item previous to number entered into string
  ', ' + lists [val5 - 1] + ', ' + lists [val6 - 1] + ' and ' + lists [val7 - 1]   # Displays item previous to number entered into string
  end  # Ends if statement

puts  # Puts a space

puts 'What would you like to do next, press enter to repeat, press(E) to exit!'  # Displays string
STDOUT.flush  # Allows ruby to work with SciTE
ans = gets.chomp.downcase  # Gets ans in lowercase

puts  # Puts a space

if ans == 'e'  # If statement with condition
  puts 'GoodBye!';break  # Displays string then breaks while true loop
end  # Ends if statement
end  # End while true loop
