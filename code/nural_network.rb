#Anders Wilson
#andwilson.assignment3.rb
#nueral network
#9-28-2010

#genral intro
puts "There are two layers of neurons."
puts "Layer 1 has 3 neurons and layer 2 has 2."
puts "every neuron has two inputs, and layer 2 gets inputs from layer 1."
puts ""

l1ar = [] # layer 1 potential array
l2ar = [] # layer 2 potential array

l1war = [] # layer 1 weight array    - be advised  the 0th and 3rd are pairs
l2war = [] # layer 2 weight array    - be advised  the 0th and 3rd are pairs

l1trigs = [] # bool value array for layer 1 triggering - be advised  the 0th and 3rd are pairs
l2trigs = [] # bool value array for layer 2 triggering - be advised  the 0th and 3rd are pairs

tt = 0 # value of trigger weights


#loop for layer 1
puts "Now entering info for Layer 1."
puts ""
i = 0 #loop iterator
while i < 3
  puts "Enter Action Potential for Neuron #{i + 1}: "
  l1ar[i]=gets.to_i
  puts "Enter First Weight for for Neuron #{i + 1}: "
  l1war[i]=gets.to_i
  puts "Enter Second Weight for for Neuron #{i + 1}: "
  l1war[i+3]=gets.to_i   #need to assign to the 3rd spot to pair with 0th etc.
  puts ""
  i = i+1
end


#loop for layer 2
puts ""
puts "Now entering info for Layer 2. "
puts ""
i = 0 #loop iterator
while i < 3
  puts "Enter action potential for Neuron #{i + 1}: "
  l2ar[i]=gets.to_i
  puts "Enter First weight for for Neuron #{i + 1}: "
  l2war[i]=gets.to_i
  puts "Enter Second weight for for Neuron #{i + 1}: "
  l2war[i+3]=gets.to_i   #need to assign to the 3rd spot to pair with 0th etc.
  puts ""
  i = i+1
end




#enter bool value for layer inputs
puts ""
puts "Now enter True or False for the neuron inputs as '1' or as '0' "
puts ""

i = 0 #loop iterator
while i < 3
  puts "For neuron #{i + 1} enter First Trigger value: "
  l1trigs[i]=gets.to_i
  puts "For neuron #{i + 1} enter First Trigger value: "
  l1trigs[i+3]=gets.to_i
  puts ""
  i = i + 1
end

#process inputs weights and triggers for layer 1
i = 0 #loop iterator
while i < 3
  tt = 0
  if l1trigs[i] == 1
    tt = l1war[i]
  end
  if l1trigs[i+3] == 1
    tt = tt + l1war[i + 3]
  end
  #saves t/f value for next layer and returns if neurons had fired
  if tt > l1ar[i]
    l2trigs[i] = 1
    puts "Level 1 neuron #{i+1} has fired."
  else
    l2trigs[i] = 0
    puts "Level 1 neuron #{i+1} has not fired."
  end
  i = i + 1
end


#saves t/f value for next layer and returns if neurons had fired
 i = 0 #loop iterator
while i < 3
  tt = 0
   if l2trigs[i] == 1
    tt = l2war[i]
  end
  if l2trigs[i+3] == 1
    tt = tt + l2war[i + 3]
  end

  #saves t/f value for next layer and returns if neurons had fired
  if tt > l2ar[i]
    l2trigs[i] = 1
    puts "Level 2 neuron #{i+1} has fired."
  else
    l2trigs[i] = 0
    puts "Level 2 neuron #{i+1} has not fired."
  end
  i = i + 1
end

#all set and all good :)






