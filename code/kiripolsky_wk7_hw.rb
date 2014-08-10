def Main()
	dates_array = Array.new()
	organism_array = Array.new()
	gene_array = Array.new()
	gene_array_lengths = Array.new()

	dates_array2 = Array.new()
	organism_array2 = Array.new()
	gene_array2 = Array.new()
	gene_array_lengths2 = Array.new()

	file_name = "U20753.gb"
	file_name2 = "U96639.gb"

	File.open(file_name2).each do |file_line|
		#opening the file and scanning it line by line.  This gives us a string
		#so it is possible to scan the string with a regex and store that
		#result in an array
																#Block form
		file_line.scan(/\(([0-9]{2}+\-+[A-Z]{3}+\-[0-9]{4})\)/) {|match| dates_array.push(match)} 
		#Looking for newest publication date--Matches publication dates in the form dd-mm-yyyy
		file_line.scan(/ORGANISM/) { |match|  organism_array.push(file_line)}
		#Looking for the Organism Name
		file_line.scan(/(gene+\=.*[A-z\d]+)/) { |match| gene_array.push(file_line) }
		#Looking for the number of genes in the file; grabs the gene name
		if file_line =~ /gene[^\d]*([\d]+\.\.+.*[\d])/
			# Could not for the life of me figure out how to do this with 
			# file_line.scan so I resorted to using the old way
			gene = $1.sub("..","-")
			gene_array_lengths.push((eval(gene))*-1)
			#looking for the length of each gene
		end
		
	end
	seperator = "*--------------------------*--------------------------*"
	index = dates_array.max
	date_index = dates_array.index(index)
	pub_date = dates_array[date_index][0]
	# grabbing the publishing date
	puts seperator
	puts "+*****************"+"File Name: "+file_name2.to_s+"*****************+"
	puts seperator
	puts "Publication Date: "+ (pub_date.to_s)
	puts seperator
	puts "Source Organism: " + organism_array[0].delete("ORGANISM").to_s.strip
	puts seperator
	puts "Number of Unique Genes: "+ gene_array.uniq.count.to_s
	for i in 0..(gene_array.uniq.count)-1
		#Printing out the unique genes
		gene_name = gene_array.uniq[i].to_s.delete("/gene=")
		gene_name = gene_name.delete('"')
		puts "\t"+(i+1).to_s+":--> " + gene_name.to_s.strip
	end
	puts seperator

	max_gene = gene_array_lengths.max
	max_gene_index = gene_array_lengths.index(max_gene)
	#Finding the index where the largest gene length is.
	min_gene = gene_array_lengths.min
	min_gene_index = gene_array_lengths.index(min_gene)
	#Finding the index where the smallest gene length is.
	gene_name_max = gene_array.uniq[max_gene_index].to_s.delete("/gene=")
	gene_name_max = gene_name_max.delete('"').strip
	#The Largest Gene
	gene_name_min = gene_array.uniq[min_gene_index].to_s.delete("/gene=")
	gene_name_min = gene_name_min.delete('"').strip
	#The Smallest Gene
	puts "Max Gene Length: " + gene_array_lengths[max_gene_index].to_s+ " Base Pairs," + " ==> Gene: " + gene_name_max.to_s
	puts "Min Gene Length: " + gene_array_lengths[min_gene_index].to_s+ " Base Pairs," + " ==> Gene: " + gene_name_min.to_s
	puts seperator

end

def Enhance()
	file_name = "U20753.gb"
	file_name2 = "U96639.gb"

	dates_array = Array.new()
	organism_array = Array.new()
	gene_array = Array.new()
	gene_array_lengths = Array.new()

	dates_array2 = Array.new()
	organism_array2 = Array.new()
	gene_array2 = Array.new()
	gene_array_lengths2 = Array.new()

	File.open(file_name).each do |file_line|
		#opening the file and scanning it line by line.  This gives us a string
		#so it is possible to scan the string with a regex and store that
		#result in an array
		file_line.scan(/(gene+\=.*[A-z\d]+)/) { |match| gene_array.push(file_line) }
		#Looking for the number of genes in the file; grabs the gene name
		if file_line =~ /gene[^\d]*([\d]+\.\.+.*[\d])/
			# Could not for the life of me figure out how to do this with 
			# file_line.scan so I resorted to using the old way
			gene = $1.sub("..","-")
			gene_array_lengths.push((eval(gene))*-1)
			#looking for the length of each gene
		end
	end
	gene_array = gene_array.uniq
	for i in 0..gene_array.size
		#Removing Duplicates and editing Gene names so that just the gene names are captured
		gene_name = gene_array[i].to_s.delete("/gene=")
		# puts gene_name
		gene_name = gene_name.delete('"')
		# puts gene_name
		gene_array[i] = gene_name.to_s.strip
		# puts gene_array[i]
	end
	gene_array.reject! { |c| c.empty? }
	#Removing Empty spaces in array

	File.open(file_name2).each do |file_line|
		#opening the file and scanning it line by line.  This gives us a string
		#so it is possible to scan the string with a regex and store that
		#result in an array
		file_line.scan(/(gene+\=.*[A-z\d]+)/) { |match| gene_array2.push(file_line) }
		#Looking for the number of genes in the file; grabs the gene name
		if file_line =~ /gene[^\d]*([\d]+\.\.+.*[\d])/
			# Could not for the life of me figure out how to do this with 
			# file_line.scan so I resorted to using the old way
			gene2 = $1.sub("..","-")
			gene_array_lengths2.push((eval(gene2))*-1)
			#looking for the length of each gene
		end
		
	end
	gene_array2 = gene_array2.uniq
	for i in 0..gene_array2.size
		#Removing Duplicates and editing Gene names so that just the gene names are captured
		gene_name2 = gene_array2[i].to_s.delete("/gene=")
		gene_name2 = gene_name2.delete('"')
		gene_array2[i] = gene_name2.to_s.strip
	end
	gene_array2.reject! { |c| c.empty? }
	#Removing Empty spaces in array

	puts "Let's compare Genes between the two files.  Please enter a Gene name: "
	user_gene_name = gets.chomp.to_s

	g1_index = gene_array.index(user_gene_name) #filename
	g2_index = gene_array2.index(user_gene_name) #filename2
	#Grabbing the indexes of the genes the user entered
	if gene_array_lengths[g1_index] > gene_array_lengths2[g2_index]
		puts "The Gene is longer in #{file_name}"
	elsif gene_array_lengths[g1_index] < gene_array_lengths2[g2_index]
		puts "The Gene is longer in #{file_name2}"
	else
		puts "The Gene is the same length in both files."
	end
	puts "Here is the Length of #{user_gene_name} in #{file_name}: " + gene_array_lengths[g1_index].to_s
	puts "Here is the Length of #{user_gene_name} in #{file_name2}: " + gene_array_lengths2[g2_index].to_s

	puts "Would you like to compare more Genes? y or n?"
	y_or_n = gets.chomp.to_s

	while y_or_n == "y" do
		puts "Please enter a Gene name: "
		user_gene_name = gets.chomp.to_s

		for i in 0..gene_array2.size
			#Removing Duplicates and editing Gene names so that just the gene names are captured
			gene_name2 = gene_array2.uniq[i].to_s.delete("/gene=")
			gene_name2 = gene_name2.delete('"')
			gene_array2[i] = gene_name2.to_s.strip
		end
		gene_array2.reject! { |c| c.empty? }
		#Removing Empty spaces in array
		for i in 0..gene_array.size
			#Removing Duplicates and editing Gene names so that just the gene names are captured
			gene_name = gene_array.uniq[i].to_s.delete("/gene=")
			gene_name = gene_name.delete('"')
			gene_array[i] = gene_name.to_s.strip
		end
		g1_index = gene_array.index(user_gene_name) #filename
		g2_index = gene_array2.index(user_gene_name) #filename2
		#Grabbing the indexes of the genes the user entered

		puts "Here is the Length of #{user_gene_name} in #{file_name}: " + gene_array_lengths[g1_index].to_s
		puts "Here is the Length of #{user_gene_name} in #{file_name2}: " + gene_array_lengths2[g2_index].to_s

		if gene_array_lengths[g1_index] > gene_array_lengths2[g2_index]
			puts "The Gene is longer in #{file_name}"
		elsif gene_array_lengths[g1_index] < gene_array_lengths2[g2_index]
			puts "The Gene is longer in #{file_name2}"
		else
			puts "The Gene is the same length in both files."
		end

		puts "Would you like to compare more Genes? y or n?"
		y_or_n = gets.chomp.to_s
	end
	puts "Thanks for playing!"


end


Main()
Enhance()