#!/usr/bin/env ruby

# Convert jMemorize JML files to Mnemosyne XML, which can be imported to
# AnyMemo, Mnemosyne and possibly others.
# The JML files should be uncompressed (Use 7-Zip or gunzip if necessary).

# Only two-sided cards with plain syntax which have been learned one way
# (front to back) are supported, and category information is discarded.

require 'date'

if ARGV.length < 2
	puts "Usage: ruby " << $0 << " <infile.jml> <outfile.xml>"
	exit
end

open(ARGV[1], 'w') do |outfile|

	outfile.puts '<?xml version="1.0" encoding="UTF-8"?>'
	# The creation date is relative to the Unix epoch in the Mnemosyne format.
	# Pretend the database was created at the Unix epoch.
	outfile.puts '<mnemosyne core_version="1" time_of_start="0">'

	open ARGV[0] do |infile|

		# Read the JML file line by line.
		while line = infile.gets

			if line.match("<Card")

				# Extract data for each card from the JML format.
				back_side	= line.match('Backside="(.*?)"')[1]
				front_side	= line.match('Frontside="(.*?)"')[1]
				last_test	= Date.parse(line.match('DateTested="(.*?)"')[1])
				next_test	= Date.parse(line.match('DateExpired="(.*?)"')[1])
				tests_total	= line.match('TestsTotal="(.*?)"')[1].to_i
				tests_hit	= line.match('TestsHit="(.*?)"')[1].to_i

				# Output the card in the Mnemosyne XML format.

				outfile.write '<item'
				outfile.write ' id="' << (front_side + back_side).hash.to_s(16) << '"'

				# jMemorize's deck system doesn't map readily to Mnemosyne's group system.
				# Choose group 4 as a default choice.
				outfile.write ' gr="4"'

				# The "ease factor" defaults to 2.0, which corresponds to the "Exponential"
				# scheduling setting in jMemorize. Somewhere between 1.23 and 1.78 could be
				# used for the "Quadratic" setting and 1.11-1.5 for the "Linear" setting,
				# though Mnemosyne may alter this value later.
				outfile.write ' e="2.000"'

				# Number of times the card's been repeated.
				# ac_rp are the first two; rt_rp the subsequent ones.
				# _l means repetitions since the card was last forgotten.
				# Set the _l repetitions equal to the total repetitions.
				if tests_total <= 2
					outfile.write ' ac_rp="' << tests_total.to_s << '" ac_rp_l="' <<
					tests_total.to_s << '" rt_rp="0" rt_rp_l="0"'
				else
					outfile.write ' ac_rp="2" ac_rp_l="2" rt_rp="' << (tests_total-2).to_s <<
				'" rt_rp_l="' << (tests_total-2).to_s << '"'
				end

				# Number of times the card's been forgotten.
				outfile.write ' lps="' << (tests_total - tests_hit).to_s << '"'

				# Last repetition. Dates are relative to the database creation date.
				outfile.write ' l_rp="' << (last_test.strftime('%s').to_i/(1440*60)).to_s << '"'

				# Next repetition. Dates are relative to the database creation date.
				outfile.write ' n_rp="' << (next_test.strftime('%s').to_i/(1440*60)).to_s << '"'

				outfile.puts '>'

				# Front side of the card.
				outfile.puts ' <Q>' << front_side << '</Q>'

				# Back side of the card.
				outfile.puts ' <A>' << back_side << '</A>'

				outfile.puts '</item>'

			end

		end

	outfile.write '</mnemosyne>'

	end

end
