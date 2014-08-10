a = [ "number", 1, 2, 3.14 ] # array with four elements
puts a[0] # access and display the first element #=> "numbers"
a[3] = nil # set the last element to nil
puts a # access and display entire array #=> numbers, 1, 2, nil

myarray = [ 1, 2, 3, 4, 5, 6 ]
puts myarray[0] #=>1
puts myarray[1...3] #exclusive range: 2 3
puts myarray[1..3] #inclusive range: 2 3 4
puts myarray[1,3]# denotes range between 1st up to 3rd consecutive, inclusive: 2 3 4

a = [ "pi", 3.14, "prime", 17 ]
puts a.class #=> Array
puts a.length #=> 4
puts a[0] #=>	pi
puts a[-1] #=> 17
puts a[1] #=>	3.14
puts a[2] #=>	prime
puts a[3] #=>	17
puts a[4] #=> nil

b = Array.new
puts b.class #=>	Array
puts b.length #=>	0
b[0] = "a"	
b[1] = "new"
b[2] = "array"
puts b #=>	a new array