#!/usr/bin/env ruby

require 'optparse'
require 'optparse/time'
require 'ostruct'
require 'pp'

class OptionParse
	#
	# Return a structure describing the options.
	#
	def self.parse(args)
		# The options specified on the command line will be collected in *options*.
		# We set default values here.
		options = OpenStruct.new
		
		opts = OptionParser.new do |opts|
			opts.banner = "Usage: build_make.rb [options]"
		
			opts.separator ""
			opts.separator "Specific options:"
		
			# Mandatory argument.
			opts.on("-s", "--samples FILE",
				"") do |samples_file_name|
				options.samples_file_name = samples_file_name
			end
		end
		
		opts.parse!(args)
		options
	end  # parse()

end  # class OptparseExample

options = OptionParse.parse(ARGV)

active_samples = Array.new()
samples_file = File.open(options.samples_file_name)
samples_file.each_with_index do |line,i|
	if i > 0 
		if line.split("\t")[6].strip != ""
			active_samples << line
		end
	end
end

# Build tophat alignments and cufflinks quantifications
comparable_strains = Hash.new()
active_samples.each_with_index do |sample,i| 
	sample_name = sample.split("\t")[0..5].join("-")

	puts "tophat/" + sample_name + "/accepted_hits.bam : " + sample.split("\t")[6].strip
	puts "\trm -rf ./tophat/" + sample_name + " ; tophat -g 1 -o ./tophat/" + sample_name + " H99/bowtie_index/crNeoH99 " + sample.split("\t")[6].strip.split(" ").join(",")

	puts "tophat/" + sample_name + "/summary.txt: tophat/" + sample_name + "/accepted_hits.bam " + sample.split("\t")[6].strip
	puts "\ttools/summarize.readcounts tophat/" + sample_name + " " + sample.split("\t")[6].strip.split(" ").join(",") + " > tophat/" + sample_name + "/summary.txt"

	puts "cufflinks/" + sample_name + "/genes.fpkm_tracking: tophat/" + sample_name + "/accepted_hits.bam"
	puts "\trm -rf cufflinks/" + sample_name + " ; cufflinks -G H99/crNeoH99.gtf -F 0 -j 0 -N -o cufflinks/" + sample_name + " tophat/" + sample_name + "/accepted_hits.bam"

	sampleinfo = sample.split("\t")
	prep_key = sampleinfo[1] + "-" + sampleinfo[3] + "-" + sampleinfo[4]
	if comparable_strains[prep_key].nil?
		comparable_strains[prep_key] = Hash.new()
	end
	if comparable_strains[prep_key][sampleinfo[0]].nil?
		comparable_strains[prep_key][sampleinfo[0]] = Array.new()
	end
	comparable_strains[prep_key][sampleinfo[0]] << i 
end
puts "TOPHAT_ALIGNMENTS = " + active_samples.map {|sample| "tophat/" + sample.split("\t")[0..5].join("-") + "/accepted_hits.bam" }.join(" ")
puts "TOPHAT_SUMMARIES = " + active_samples.map {|sample| "tophat/" + sample.split("\t")[0..5].join("-") + "/summary.txt" }.join(" ")
puts "CUFFLINKS_QUANTS = " + active_samples.map {|sample| "cufflinks/" + sample.split("\t")[0..5].join("-") + "/genes.fpkm_tracking" }.join(" ")

# Build expression files:
comparable_strains.each do |prep_key,strains|
	strains.each do |strain,replicates|
		replicates.each do |sample_indx|
			sample_name = active_samples[sample_indx].split("\t")[0..5].join("-")
			puts "expression/" + sample_name + ".expr: cufflinks/" + sample_name + "/genes.fpkm_tracking"
			puts "\tcut -f 1,10 cufflinks/" + sample_name + "/genes.fpkm_tracking | sed -e '1d' | sort | sed -e 's/[^\t]*\t//' > expression/" + sample_name + ".expr"
		end
		fpkms = replicates.map {|sample_indx| "cufflinks/" + active_samples[sample_indx].split("\t")[0..5].join("-") + "/genes.fpkm_tracking" }
	end
end
puts "EXPRESSION_FILES = " + active_samples.map {|sample| "expression/" + sample.split("\t")[0..5].join("-") + ".expr" }.join(" ")

# Build CUFFDIFF differential expression comparisons:
#cuffdiff_comparisons = Array.new()
#comparable_strains.each do |prep_key,strains|
#	strains.each do |strain,replicates|
#		if strain != "00000" # do not compare WT to WT
#			#WT available?
#			if !strains["00000"].nil? 
#				comparison_label = "00000-" + strain + "-" + prep_key
#
#				cuffdiff_comparisons << "prefilter/cuffdiff/" + comparison_label + "/interactions"
#				mutant_expr = replicates.map {|sample_indx| "tophat/" + active_samples[sample_indx].split("\t")[0..5].join("-") + "/accepted_hits.bam" }
#				wt_expr = strains["00000"].map{|sample_indx| "tophat/" + active_samples[sample_indx].split("\t")[0..5].join("-") + "/accepted_hits.bam" }
#				puts "prefilter/cuffdiff/" + comparison_label + "/interactions: " + mutant_expr.join(" ") + " " + wt_expr.join(" ")
#				puts "\trm -rf prefilter/cuffdiff/" + comparison_label + " ; mkdir prefilter/cuffdiff/" + comparison_label + " ; cuffdiff -L " + strain + ",00000 -N H99/crNeoH99.gtf -o prefilter/cuffdiff/" + comparison_label + " " + mutant_expr.join(",") + " " + wt_expr.join(",") + "; grep yes prefilter/cuffdiff/" + comparison_label + "/gene_exp.diff | cut -f 1 > prefilter/cuffdiff/" + comparison_label + "/de.genes; cut -f 1,10,12,13 prefilter/cuffdiff/" + comparison_label + "/gene_exp.diff | sed -e 's/^/CNAG_" + strain  + "\t/' | sed -e '1d' > prefilter/cuffdiff/" + comparison_label + "/interactions"
#			end
#		end
#	end
#end
#puts "CUFFDIFF_COMPARISONS = " + cuffdiff_comparisons.join(" ")
#
# Build DEseq differential expression comparisons:
#deseq_comparisons = Array.new()
#comparable_strains.each do |prep_key,strains|
#	strains.each do |strain,replicates|
#		if strain != "00000" # do not compare WT to WT
#			#WT available?
#			if !strains["00000"].nil? 
#				comparison_label = "00000-" + strain + "-" + prep_key
#				deseq_comparisons << "prefilter/deseq/" + comparison_label + "/interactions"
#				mutant_expr = replicates.map {|sample_indx| "tophat/" + active_samples[sample_indx].split("\t")[0..5].join("-") + "/accepted_hits.bam" }
#				wt_expr = strains["00000"].map{|sample_indx| "tophat/" + active_samples[sample_indx].split("\t")[0..5].join("-") + "/accepted_hits.bam" }
#				mutant_id = replicates.map {|sample_indx| strain + "-" + active_samples[sample_indx].split("\t")[2] }
#				wt_id = strains["00000"].map{|sample_indx| "00000-" + active_samples[sample_indx].split("\t")[2] }
#				puts "prefilter/deseq/" + comparison_label + "/interactions: " + mutant_expr.join(" ") + " " + wt_expr.join(" ")
#				makeline = "\trm -rf prefilter/deseq/" + comparison_label + " ; mkdir prefilter/deseq/" + comparison_label + " ; "
#				makeline += "cp H99/gids prefilter/deseq/" + comparison_label + " ; "
#				mutant_expr.each_with_index do |expr,i|
#					makeline += "samtools view " + expr + " >  prefilter/deseq/" + comparison_label + "/"  + mutant_id[i] + ".sam ; python -m HTSeq.scripts.count --stranded=no prefilter/deseq/" + comparison_label + "/"  + mutant_id[i] + ".sam H99/crNeoH99.gtf | grep -F -f H99/gids > " + "prefilter/deseq/" + comparison_label + "/"  + mutant_id[i] + ".counts ; "
#				end
#				wt_expr.each_with_index do |expr,i|
#					makeline += "samtools view " + expr + " >  prefilter/deseq/" + comparison_label + "/"  + wt_id[i] + ".sam ; python -m HTSeq.scripts.count --stranded=no prefilter/deseq/" + comparison_label + "/"  + wt_id[i] + ".sam H99/crNeoH99.gtf | grep -F -f H99/gids > " + "prefilter/deseq/" + comparison_label + "/"  + wt_id[i] + ".counts ; "
#				end
#				makeline += "sed -i -e 's/^[^\t]*\t//' prefilter/deseq/" + comparison_label + "/*.counts ; "
#				makeline += "echo " + mutant_expr.map{|a| strain }.join(" ") + " " + wt_expr.map{|a| "00000" }.join(" ") + " > prefilter/deseq/" + comparison_label + "/design ; cd prefilter/deseq/" + comparison_label + " ; "
#				makeline += "paste " + mutant_id.map{|id| id + ".counts" }.join(" ") + " " + wt_id.map{|id| id + ".counts" }.join(" ") + " > all.counts ;"
#				makeline += "R --slave --no-save < ../../../tools/deseq.r ; sed -e 's/^/CNAG_" + strain  + "\t/' DESeq_summary.fc_p_q > interactions ; cd ../../.. ; "
#				puts makeline
#			end
#		end
#	end
#end
#puts "DESEQ_COMPARISONS = " + deseq_comparisons.join(" ")




cov_comparisons = Array.new()
comparable_strains.each do |prep_key,strains|
	strains.each do |strain,replicates|
		comparison_label = strain + "-" + prep_key
		cov_comparisons << "prefilter/cov/" + comparison_label + ".cov"
		expr = replicates.map {|sample_indx| "expression/" + active_samples[sample_indx].split("\t")[0..5].join("-") + ".expr" }
		puts "prefilter/cov/" + comparison_label + ".cov: " + expr.join(" ") 
		puts "\techo \""+ comparison_label.split("-").join("\t") + "\t$$(tools/eval.cov.rb -i " + expr.join(",") + ")\" > prefilter/cov/" + comparison_label + ".cov"
	end
end
puts "COV_COMPARISONS = " + cov_comparisons.join(" ")



# Summarize alignments
puts "reports/alignment_summary.txt: $(TOPHAT_SUMMARIES)"
puts "\techo 'GENOTYPE	TREATMENT	REPLICATE	INDUCTION	LIBRARY	SAMPLE	TOTAL	ALIGNED	SINGLY_ALIGNED_UNIQUE	COMPLEXITY UNIQUE' > reports/alignment_summary.txt ; cat $$(ls -t tophat/*/summary.txt) | grep -v GENOTYPE >> reports/alignment_summary.txt"

# Summarize COVs
puts "reports/cov_summary.txt: $(COV_COMPARISONS)"
#puts "\techo 'GENOTYPE	TREATMENT	INDUCTION	LIBRARY	REPLICATES	COV_MEAN	COV_MEDIAN	K=0	K=1	K=2	K=3' > reports/cov_summary.txt ; cat $$(ls -t prefilter/cov/*) >> reports/cov_summary.txt"
puts "\techo 'GENOTYPE	TREATMENT	INDUCTION	LIBRARY	REPLICATES	COV_MEDIAN	COV_MEDIAN_REPS_12	COV_MEDIAN_REPS_13	COV_MEDIAN_REPS_23	K=0	K=1	K=2	K=3' > reports/cov_summary.txt ; cat $$(ls -t prefilter/cov/*) >> reports/cov_summary.txt"

# Summarize deleted ORFS
puts "reports/deleted_orf_summary.txt: $(EXPRESSION_FILES)"
puts "\tcd expression; ../tools/summarize.deleted.orfs | sed -e 's/ /\\t/g' > ../reports/deleted_orf_summary.txt ; cd ..;"

# Summarize resistance ORFS
puts "reports/resistance_orf_summary.txt: $(EXPRESSION_FILES)"
puts "\tcd expression; ../tools/summarize.resistancecassettes | sed -e 's/ /\\t/g' > ../reports/resistance_orf_summary.txt ; cd ..;"

puts "REPORTS = reports/alignment_summary.txt reports/cov_summary.txt reports/deleted_orf_summary.txt reports/resistance_orf_summary.txt"

puts "all: $(TOPHAT_ALIGNMENTS) $(TOPHAT_SUMMARIES) $(CUFFLINKS_QUANTS) $(EXPRESSION_FILES) $(COV_COMPARISONS) $(REPORTS)"
