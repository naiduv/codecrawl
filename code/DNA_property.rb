
#--------------------------------------------------
# DNA_property.rb
# Author : Yasumasa Kimura 
# Date : 2009/02/09
#--------------------------------------------------

#require 'tempfile'

class DNA_property

	def initialize(my_sequence, my_dir_tmp=Dir::pwd)
		@sequence = my_sequence
		@dir_tmp = my_dir_tmp
	end

	#------------------------------
	# get reverse complimentary
	def get_revcom
		rev = @sequence.reverse
		@revcom = rev.tr('acgtrymkswhbvdnxACGTRYMKSWHBVDNX', 'tgcayrkmswdvbhnxTGCAYRKMSWDVBHNX')
		return @revcom
	end

	#------------------------------
	# get dG of self-folding
	def get_dG_mfold(name, pdf=false)
		# directory change
		dir_org = Dir::pwd
		Dir::chdir(@dir_tmp)
		@dG_mfold = ""

		# input of mfold
		seq_ = name + ".seq"
		f_seq = open(seq_,"w")
		#f_seq.puts ">" + name
		f_seq.puts @sequence
		f_seq.close

		# run mfold
		#log_ = name + ".mf.log"
		log_ = name + ".dG"
		#mfold_ = "| mfold SEQ=" + seq_ + " T=60 NA=DNA NA_CONC=0.01 MG_CONC=0.008 > " + log_ # using mfold
		mfold_ = "| hybrid-ss-min --mfold --NA DNA --tmin 60 --tmax 60 --sodium 0.01 --magnesium 0.008 " + seq_
		f_mfold = open(mfold_)
		f_mfold.close

		# parse result
		f_log = open(log_)
		while line = f_log.gets
			line.chomp!
			#puts line
			#if line =~ /^Minimum folding energy is (-?\d+\.\d+) kcal\/mol\.$/ then
			if line =~ /^\d+\s(-?\d+\.\d+)\s/ then
				dG_mfold = $1
				break
			else
				dG_mfold = ""
			end
		end
		f_log.close

		File.unlink(log_)
		#if pdf then
			#f_cp = open("| cp  #{name}_1.pdf  #{dir_org}")
			#f_cp.close
		#end
		f_rm = open("| rm " + name + "*")
		f_rm.close

		Dir::chdir(dir_org)
		return dG_mfold
	end

	#------------------------------
	# get dG of hybridization
	def get_hybrid_2s(name, template)
		# directory change
		dir_org = Dir::pwd
		Dir::chdir(@dir_tmp)

		# query file
		query_ = name + ".q.seq"
		f_query = open(query_,"w")
		f_query.puts ">query." + name
		f_query.puts @sequence
		f_query.close

		# template file
		template_ = name + ".t.seq"
		f_template = open(template_,"w")
		f_template.puts ">template." + name
		f_template.puts template
		f_template.close

		# run hybrid2.pl
		f_hybrid2 = open("| hybrid-2s.pl --NA DNA --tmin 60 --tmax 60 --sodium 0.01 --magnesium 0.008 #{query_} #{template_} > log.txt")
		f_hybrid2.close

		# read dG query - template
		dG_query_template = nil
		dG_ = name + ".q-" + name + ".t.dG"
		f_dG = open(dG_)
		while line = f_dG.gets
			line.chomp!
			if line =~ /^60/
				dG_query_template = (line.split("\t"))[1]
			end
		end
		f_dG.close

		f_rm = open("| rm ./#{name}.*")
		f_rm.close
		Dir::chdir(dir_org)
		return dG_query_template
	end

	#------------------------------
	# ssearch : position search
	def ssearch(name, direction, template, ret="5end")
		# directory change
		dir_org = Dir::pwd
		Dir::chdir(@dir_tmp)

		# query file
		query_ = name + ".q.fa"
		f_query = open(query_,"w")
		f_query.puts ">query." + name
		f_query.puts @sequence
		f_query.close

		# template file
		template_ = name + ".t.fa"
		f_template = open(template_,"w")
		f_template.puts ">template." + name
		f_template.puts template
		f_template.close

		# ssearch
		ck_start = nil
		start = nil
		sw_frame = nil
		#f_ssearch = open(["| /usr/local/bin/ssearch35_t -nqH -b 1 -d 1 -m 10", query_, template_].join(" "))
		f_ssearch = open(["| ssearch35_t -nqH -b 1 -d 1 -m 10", query_, template_].join(" "))
		while line = f_ssearch.gets
			line.chomp!

			# check direction
			if line =~ /sw_frame: (\w)/ then
				sw_frame = $1
				if direction == nil then
					direction = sw_frame.upcase
				elsif direction.upcase != sw_frame.upcase then
					raise("It matches with wrong direction.")
				end
			end

			if line =~ /sw_ident: (\S+)/ then
				identity = $1.to_i
				if identity < 1 then
					warn(["Identity error: ", identity, name, direction, @sequence, template].join("\t"))
				end
			end

			# start
			if line !~ /^>#{name}/ && line =~ /^>[^>]/ then
				ck_start = 1
			elsif ck_start == 1 then
				if ret == "5end" then
					# 5'end position
					if direction == "F" && line =~ /al_start:\s+(\d+)/ then
						start = $1
					elsif  direction == "R" && line =~ /al_stop:\s+(\d+)/ then
						start = $1
					end
				else
					# 3'end position
					if direction == "R" && line =~ /al_start:\s+(\d+)/ then
						start = $1
					elsif  direction == "F" && line =~ /al_stop:\s+(\d+)/ then
						start = $1
					end
				end
			elsif line =~ /^>/ then
				ck_start = 0
			end
		end
		f_ssearch.close

		File.unlink(query_)
		File.unlink(template_)

		Dir::chdir(dir_org)
		return start.to_i
	end

	#------------------------------
	# get sum dG and sum length of fastagrep
	def do_fastagrep_gadg(name, template, dG, min3prim, ignore=0, both=false)
		# directory change
		dir_org = Dir::pwd
		Dir::chdir(@dir_tmp)

		# query file
		query_ = name + ".q.seq"
		f_query = open(query_,"w")
		f_query.puts ">query." + name
		f_query.puts @sequence
		f_query.close

		# template file
		template_ = name + ".t.seq"
		f_template = open(template_,"w")
		f_template.puts ">template." + name
		f_template.puts template
		f_template.close

		result = ""
		# fastagrep
		fastagrep_ = ["| fastagrep -haystack ",template_," -needle ",@sequence," -gadg ", dG, min3prim, " -ck 10 -cmg 8 -cdna 2000"].join(" ")
		f_fastagrep = open(fastagrep_)	
		s_text = "" 
		c_text = "" 
		a_s_match = []
		a_c_match = []
		n_hit = 0
		sum_dG = 0.0
		sum_l = 0.0
		sum_l_dG = 0.0
		while line = f_fastagrep.gets
			if line =~ /^DGF \d+ (-?\d+\.\d+) .+:(\d+)\-(\d+)/ then
				s_text += line
				a_s_match.push([$1,$2,$3])
			elsif line =~ /^DGR \d+ (-?\d+\.\d+) .+:(\d+)\-(\d+)/ then
				c_text += line
				a_c_match.push([$1,$2,$3])
				next if !both
			else
				raise
			end

			next if $2.to_i <= ignore
			n_hit += 1
			sum_dG += $1.to_f
			sum_l += ($2.to_i - 1.0)
			sum_l_dG += $1.to_f * ($2.to_f - 1.0)
		end
		f_fastagrep.close

		f_rm = open("| rm ./#{name}.*")
		f_rm.close
		Dir::chdir(dir_org)
		return {"n_hit" => n_hit, "sum_dG" => sum_dG, "sum_l" => sum_l, "sum_l_dG" => sum_l_dG, "s_text" => s_text, "c_text" => c_text, "a_s_match" => a_s_match, "a_c_match" => a_c_match}
	end

	#------------------------------
	# get max dG of fastagrep
	def get_max_fastagrep_gadg(name, template, dG, min3prim, ignore=0, both=false)
		# directory change
		dir_org = Dir::pwd
		Dir::chdir(@dir_tmp)

		# query file
		query_ = name + ".q.seq"
		f_query = open(query_,"w")
		f_query.puts ">query." + name
		f_query.puts @sequence
		f_query.close

		# template file
		template_ = name + ".t.seq"
		f_template = open(template_,"w")
		f_template.puts ">template." + name
		f_template.puts template
		f_template.close

		result = ""
		# fastagrep
		fastagrep_ = ["| fastagrep -haystack ",template_," -needle ",@sequence," -gadg ", dG, min3prim, " -ck 10 -cmg 8 -cdna 2000"].join(" ")
		f_fastagrep = open(fastagrep_)	
		n_hit = 0
		max_dG = 0.0
		max_l = 0 
		while line = f_fastagrep.gets
			if both then
				raise if line !~ /^\w+ \d+ (-?\d+\.\d+) .+:(\d+)\-\d+/ 
			else
				next if line !~ /^DGF \d+ (-?\d+\.\d+) .+:(\d+)\-\d+/ 
			end
			next if $2.to_i <= ignore
			n_hit += 1
			if max_dG > $1.to_f then
				max_dG = $1.to_f
				max_l = $2.to_i
			end
		end
		f_fastagrep.close

		f_rm = open("| rm ./#{name}.*")
		f_rm.close
		Dir::chdir(dir_org)
		return {"max_dG" => max_dG, "max_l" => max_l}
	end


	#------------------------------
	# get probability of pairing of new TP
	def get_prob_pair_hybrid_ss(name, primer, p_start, primer_length)
		# directory change
		dir_org = Dir::pwd
		Dir::chdir(@dir_tmp)

		in_ = "#{name}.in.fa"
		f_in = open(in_,"w")
		f_in.puts(">" + name)
		f_in.puts(@sequence)
		f_in.close

		out_ = name
		f_hybrid_ss = open("| hybrid-ss --NA DNA --sodium 0.01 --magnesium 0.008 --tmin 60 --tmax 60 --output #{out_} #{in_}")
		f_hybrid_ss.close

		# length
		if primer != nil then
			primer_length = primer.length
			# position of 3'end of primer
			p_start = DNA_property.new(primer, @dir_tmp).ssearch("ss." + name, nil, @sequence, "3end")
			#puts p_start
		end

		# plot file from hybrid-ss
		plot_ = out_ + ".60.plot"
		f_plot = open(plot_)

		# initialize
		a_sum_prob = []
		a_sum_prob[0] = nil
		@h_prob_ss = {}
		for x in 1..primer_length
			a_sum_prob[x] = 0
			p = p_start + x - 1
			@h_prob_ss[p] = {}
			for y in 1..(@sequence.length)
				@h_prob_ss[p][y] = 0
			end
		end

		while line_plot = f_plot.gets
			line_plot.chomp!
			a_plot = line_plot.split("\t")
			prob = a_plot[2].to_f

			# sum up probability
			for x in 1..primer_length
				p = p_start + x - 1
				if a_plot[0].to_i == p then
					a_sum_prob[x] += prob
					@h_prob_ss[p][a_plot[1].to_i] = prob
				elsif a_plot[1].to_i == p then
					a_sum_prob[x] += prob
					@h_prob_ss[p][a_plot[0].to_i] = prob
				end
			end
		end
		f_plot.close

		f_rm = open("| rm #{name}*")
		f_rm.close

		Dir::chdir(dir_org)
		return a_sum_prob
	end


	#------------------------------
	attr_accessor :revcom, :h_prob_ss
end

