            #### The Untyped Lambda Calculus in Ruby ####


#The development of programming langugaes follow traditions that go back several
#decades.  Ruby is a member of a class of languages that include perl and 
#python, but also inherits essential aspects of the Lisp/Scheme languages that
#are based directly on Church's lambda calculus.

## One of the most unique features of Ruby are "blocks", which are in essense
## lambda expressions that can be integrated into programs in various ways.
## In particular, a "nameless function" can be defined by placing the
## keyword 'lambda' before a block

## simplest example:

add1 = lambda {|x| x+1}   # alternate Ruby 1.9 syntax:  add1 = ->(x){x+1}
puts add1[4]  # prints 5, can also use add1.(4) or add1.call(4)

## Because the lambda term is a pointer, a special syntax is required when
## applying the function.  Only functions defined using 'def' can be applied
## directly using f(...).


####  Now for the I, K and S combinators in Ruby:

I = lambda{|x| x}                  # also ->(x){x}, lambda x. x
K = lambda{|x| lambda{|y| x}}
S = lambda{|x| lambda{|y| lambda {|z| x[z][y[z]]}}}  #lambda xyz. x z (y z)

puts S[K][I][2]  # prints 2, since SKI beta-converts to I

## You might be tempted to define K as lambda{|x,y| x}, but that would
## be wrong: K is function that returns a function, a "curried" function.
## Note also I've assigned global vars to these expressions (using capitals)
## since lower-case vars are interpreted as local vars in Ruby.

## Ruby has a very nice feature called "Currying", named after the logician
## Haskell Curry (there's also a programming language named Haskell - but 
## that's for later).  

add = lambda{|x,y| x+y}
add3 = add.curry[3]
puts add3[5]   # prints 8

## You should be able to firgure out yourself what add.curry does.


### What does the following term reduce to?
## lambda {|x| x x}[lambda {|x| x x}]       # uncomment at your own risk.


########### EXERCISE!!
## Device an experiment, using only pure lambda terms, to determine if
## Ruby uses call-by-name or call-by-value.  That is, does it always 
## evaluate its arguments first?
###########


#### Now for the BOOLEANS (they're alive!) 

T = K   # lambda x. lambda y. x
F = K[I]  # lambda x. lambda y. y

## For the ifelse operator, I will cheat and define it as taking 3 args
## simultaneously.  I can use Currying the transform it later.

IFELSE0 = lambda {|x,a,b| x[a][b]}

# Unfortuantely this won't work because Ruby, like most languages, is
# CALL-BY-VALUE: that means the arguments are evaluated before being passed
# to the function.  This means that both alternatives will be evaluated anyway,
# which is exactly what we don't want to happen with ifelse.
# However, we can fake call-by-name by making sure that 
# IFELSE always gets a pair of subroutines.  These subroutines
# are both vacuous.  That is, instead of 3, we use lambda{|| 3}!
# then, to extract the value, we apply the sub returned by IFELSE0
# to a dummy argument (0):

IFELSE = lambda{|x,a,b| IFELSE0[x,a,b][]}

## sometimes IFELSE0 suffices, such as the following:
OR = lambda{|a,b| IFELSE0[a,T,b]}
AND = lambda{|a,b| IFELSE0[a,b,F]}
NOT = lambda{|x| IFELSE0[x,F,T]}

x=2
print IFELSE[OR[F,T], lambda{3}, lambda{4/(2-x)}]  # prints 3
#print IFELSE0[OR[F,T], 3, 4/(2-x)]  # would crash (divide by zero)

# lambda{3} is short for lambda{|| 3}, a lambda that takes dummy arg.
# However, it is still a routine, i.e., a pointer to CODE as opposed to VALUE.


#### LISP/SCHEME Style linked-list data structures:

CONS = lambda{|head,tail| lambda {|s| IFELSE0[s,head,tail]}}
CAR = lambda{|x| x[T]}
CDR = lambda{|x| x[F]}

l = CONS[2,CONS[3,CONS[5,CONS[7,CONS[11,I]]]]]  # using I for end of list
puts "\n", CAR[CDR[CDR[l]]]  # prints 5


#### For recursion/looping, we need the ***Applicative Order Y-Combinator***
# lambda M. (lambda x. M (lambda y. (x x y)))
#           (lambda x. M (lambda y. (x x y)))
### The extra lambda y ensures that the recursive calls are not made eagerly.

Y = lambda {|m| u = lambda {|x| m[lambda {|y| x[x][y]}]};  u[u]}

## the assignment to u (like let in scheme), made the expression shorter

## now define recursive n-factorial function, using Ruby's built-in ifelse
## for convenience (we could also use our own, with some more development)

fact = Y[ lambda{|f| lambda{|n| if n<2 then 1 else n*f[n-1] end}} ]

print "6! is ", fact[6], "\n"   # prints 6! is 720

