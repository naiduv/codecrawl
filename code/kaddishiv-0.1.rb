#Kaddish (Part IV) by Allen Gingsberg, translated to Ruby by Shy Mukerjee (subject@shymukerjee.com)
#Version 0.1
#Kaddish Copyright (c) 1957-9 Allen Ginsberg
#Code Copyright (c) 2008 Shy Mukerjee

#Sets up the arrays of parts of speech, and randomizes them

singularNouns = Array["shoe","Communist Party","shoestring","beard","belly","stocking","Trotsky","Spanish War","Hitler","dress","Russia","money","China","Aunt Elanor","India","America","lobotomy","divorce","stroke","abortion","painting class","Ma Rainey","Czechoslovakia","the killer Grandma"].sort_by {rand}
pluralNouns = Array["hairs","short stories","workers","strikes","smokestacks","porches","mandolins","relatives"].sort_by {rand}
adjectives = Array["false","dark","black","black","long","broken","old","long","sagging","bad","rotten","fat","overbroken"].sort_by {rand}
prepositionalPhrases = Array["around the vagina","on the wen","of your breast","of bad lay","of the smell","of the pickles","of Newark","for the decaying","in the park","at the piano","in California","in an ambulance","by robots","at night","in the Bronx","on the horizon","from the Fire-Escape","out of the apartment","into the hall","to an ambulance","on the operating table","by policemen"].sort_by {rand}
bodyParts = Array["fear","mouth","fingers","arms","belly","chin","pancreas","appendix","ovaries"].sort_by {rand}
verbs = Array["starving","singing","pissing","running naked","being led away","strapped down","dying","attacked","going","screaming","removed"].sort_by {rand}

#Anaphora 1 -- O mother, etc.

puts "O mother\nwhat have I left out\nO mother\nwhat have I forgotten"

#Anaphora 2 -- farewell, etc.

puts "farewell\nwith " + "a " + adjectives.pop + " " + adjectives.pop + " " + singularNouns.pop
puts "farewell\nwith " + "" + singularNouns.pop + " and a " + adjectives.pop + " " + singularNouns.pop
puts "farewell\nwith " + adjectives.pop + " " + adjectives.pop + " " + pluralNouns.pop + " " + prepositionalPhrases.pop + " " + prepositionalPhrases.pop
puts "farewell\nwith your " + adjectives.pop + " " + singularNouns.pop + " and a " + adjectives.pop + " " + adjectives.pop + " " + singularNouns.pop + " " + prepositionalPhrases.pop
puts "farewell"

#Anaphora 3 -- with your sagging belly, etc.

puts "with your " + bodyParts.pop + " of " + singularNouns.pop

  puts "with your " + bodyParts.pop + " of " + adjectives.pop + " " + pluralNouns.pop
  puts "with your " + bodyParts.pop + " of " + adjectives.pop + " " + pluralNouns.pop
  puts "with your " + bodyParts.pop + " of " + adjectives.pop + " " + pluralNouns.pop

puts "with your " + bodyParts.pop + " of " + pluralNouns.pop + " and " + pluralNouns.pop
puts "with your " + bodyParts.pop + " of " + singularNouns.pop + " and " + singularNouns.pop

puts "with your voice " + verbs.pop + " " + prepositionalPhrases.pop + " " + adjectives.pop + " " + pluralNouns.pop

#this line uses the same noun (nose, originally) twice.  So we pop singularNouns into oldNose, which is used twice.
oldNose = singularNouns.pop
puts "with your " + oldNose + " " + prepositionalPhrases.pop + " with your " + oldNose + " " + prepositionalPhrases.pop + " " + prepositionalPhrases.pop

#Anaphora 4 -- with your eyes, etc.

puts "with your eyes"
puts "with your eyes of " + singularNouns.pop
puts "with your eyes of " + singularNouns.pop
puts "with your eyes of " + adjectives.pop + " " + singularNouns.pop
puts "with your eyes of " + singularNouns.pop

#verb/obj section, ...eyes of starving India, etc.

puts "with your eyes of " + verbs.pop + " " + singularNouns.pop
puts "with your eyes " + verbs.pop + " " + prepositionalPhrases.pop

#Anaphora 5 ...America taking a fall, etc.

puts "with your eyes of " + singularNouns.pop + " taking a fall"
puts "with your eyes of your failure " + prepositionalPhrases.pop
puts "with your eyes of your " + pluralNouns.pop + " " + prepositionalPhrases.pop
puts "with your eyes of " + singularNouns.pop + " " + verbs.pop + " " + prepositionalPhrases.pop
puts "with your eyes of " + singularNouns.pop + " " + verbs.pop + " " + prepositionalPhrases.pop
puts "with your eyes going to " + singularNouns.pop + " " + prepositionalPhrases.pop
puts "with your eyes of " + singularNouns.pop + " you see " + prepositionalPhrases.pop + " " + prepositionalPhrases.pop

#Anaphora 6 ... running naked out of the apartment screaming into the hall.

puts "with your eyes " + verbs.pop + " naked " + prepositionalPhrases.pop + " " + verbs.pop + " " + prepositionalPhrases.pop
puts "with your eyes " + verbs.pop + " " + prepositionalPhrases.pop + " " + prepositionalPhrases.pop
puts "with your eyes " + verbs.pop + " " + prepositionalPhrases.pop

#Anaphora 7, surgical, legal, health section, ...eyes with the pancreas removed, etc.

puts "with your eyes with the " + bodyParts.pop + " removed"
puts "with your eyes of " + bodyParts.pop + " operation"
puts "with your eyes of " + verbs.pop
puts "with your eyes of " + bodyParts.pop + " removed"
puts "with your eyes of shock"
puts "with your eyes of " + singularNouns.pop
puts "with your eyes of " + singularNouns.pop
puts "with your eyes of " + singularNouns.pop

#ending section

puts "with your eyes alone"
puts "with your eyes"
puts "with your eyes"
puts "with your Death full of Flowers"
