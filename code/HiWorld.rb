class HiWorld
  attr_accessor :phrase
  
  #Class Constant example
  CITY = "Seattle"
  
  #Class variable
  @@num_worlds = 0
  
  #One way to create a class method:
  def HiWorld.num_worlds
    @@num_worlds
  end
  
=begin
  Two other ways to create a class method from inside the class.  
  Also, this is how you do block comments!

  def self.num_worlds
    @@num_worlds
  end

  class << self
    def num_worlds
      @@num_worlds
    end

=end
  
  #initialize with a default value
  def initialize(phrase="Hello World!")
    @phrase = phrase
    @@num_worlds += 1 #no ++ operator in Ruby!
  end
  
  def hello
    puts @phrase
  end
  
  def rainy? # not isRainy()
    true
  end
  
  #What happens if you look at an uninitialized field...
  def test_field
    puts @new_field
  end
  
  #duck typing! Don't care what type 'names' is,
  #only care what methods it has,
  def say_hi(names)
    if names.respond_to? "join"
     puts @phrase + " to everyone: " + names.join(", ") 
    else
      puts @phrase + " to you: " + names
   end
 end
 
 #a method that takes a block,
 #two ways to pass to the block
 def my_block(&p)
  yield @phrase
  p.call @phrase
end

#custom to string method (return the string)
def to_s
  @phrase
end

#private methods from here to end of class def.
private
def whisper
  puts "shh.."
end

  
end

#psuedo main method, run this if
#this file is run as an executable
if __FILE__ == $0
  g = HiWorld.new("Hi there!")
  h = HiWorld.new
  g.hello
  h.hello
  g.say_hi("Bill")
  h.say_hi(["Bob", "Jane", "Fred"])
  g.my_block {|x| puts x}
  puts
  
  #all instances of a given class
  ObjectSpace.each_object(HiWorld) {|x| p x}
  puts
  
  #Other reflective methods:
  puts "Instance variables: " 
  puts g.instance_variables
  puts
  # puts g.methods - there's a lot!
  puts "Has a to_s? " 
  puts g.respond_to?("to_s")
  puts
  puts "Is of class: "
  puts g.class
  puts
  puts "Is a kind of Object? " 
  puts g.kind_of?(Object)
  puts
  puts "Is an instance of HiWorld? " 
  puts g.instance_of?(HiWorld)
  puts
  
  #moving on to Class information..
  #setting the flags to false so only local
  #methods are displayed (not all the inherited ones)
  puts "Private Instance methods:"
  puts HiWorld.private_instance_methods(false)
  puts
  puts "Public Instance methods:"
  puts HiWorld.public_instance_methods(false)
  puts
  puts "Class constants:"
  puts HiWorld.constants
  #Accessing a class constant:
  puts HiWorld::CITY
  puts
  puts "Class variables:"
  puts HiWorld.class_variables
  puts "current class variable value: " + HiWorld.num_worlds.to_s
  puts
  puts "Singleton Methods"
  puts HiWorld.singleton_methods
  puts
  
  #Singleton example!
  puts g.respond_to?("farewell")
  puts h.respond_to?("farewell")
  
  puts "Adding farewell to h..."
  def h.farewell
    puts "Byebye!"
  end
  
  puts g.respond_to?("farewell")
  puts h.respond_to?("farewell")
  puts
 
  #Eval example.  Eval essentially treats a string as if it were
  #Ruby code, and executes it.
  
  test = "HiWorld" + ".new"
  j = eval(test)
  j.hello
  
  #Can also pass an environment (binding is a ruby method, creates
  #a binding of local variables and returns a Binding object)
  def my_env
    num=5
    return binding
  end
  b = my_env
  puts eval("num", b)
  puts
  
  #Dynamic call of methods and the to_sym method
  # :something is the symbol for something in Ruby.
  # call call the corresponding method with send:
  j.send(:hello)
  
  #can create symbols dynamically using to_sym:
  a_string = "say_hi"
  a_symbol = a_string.to_sym
  j.send(a_symbol, "Bill")
  puts
  
  #can also grab a particular method, and invoke it with call
  some_method = j.method(:say_hi)
  some_method.call "Fred"
  
  #even trickier: can grab an instance method of a class,
  #bind that method to an instantiated object, and call it!
  m1 = HiWorld.instance_method(:hello)
  m2 = m1.bind(j)
  m2.call
  
  #must bind to an instance of the class..
  #number = 5
  #m3 = m1.bind(number)
  #m3.call

  
  
  
end