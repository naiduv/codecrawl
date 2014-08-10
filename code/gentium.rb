# This file is part of the Gentium package for TeX.
# It is licensed under the Expat License, see doc//README for details.

require 'fileutils'

$TDS_ROOT = File.expand_path('../../../')
$package_name = "gentium-tug"

$path_source  = File.join($TDS_ROOT, "source", "fonts",              $package_name)
$path_ttf     = File.join($TDS_ROOT, "fonts",  "truetype", "public", $package_name)
$path_type1   = File.join($TDS_ROOT, "fonts",  "type1",    "public", $package_name)
$path_tfm     = File.join($TDS_ROOT, "fonts",  "tfm",      "public", $package_name)
$path_afm     = File.join($TDS_ROOT, "fonts",  "afm",      "public", $package_name)
$path_map_ttf = File.join($TDS_ROOT, "fonts",  "map",      "pdftex", $package_name)
$path_map     = File.join($TDS_ROOT, "fonts",  "map",      "dvips",  $package_name)
$path_enc     = File.join($TDS_ROOT, "fonts",  "enc",      "dvips",  $package_name)
$path_fd      = File.join($TDS_ROOT, "tex",    "latex",              $package_name)
$path_tmp     = File.join($TDS_ROOT, "tmp")

class Font
	def initialize(filename, name_something, filename_tex)
		@filename     = filename
		@filename_tex = filename_tex
		@name_something = name_something # TODO
		if filename =~ /Plus/ then
			@is_plus = true
		else
			@is_plus = false
		end
	end
	def is_plus?
		return @is_plus
	end

	def filename_ttf
		return "#{@filename}.ttf"
	end
	def filename_type1
		return "#{@filename}.pfb"
	end
	def filename_afm
		return "#{@filename}.afm"
	end
	def filename_pl
		return "#{@filename}.pl"
	end

	def generate_type1_with_ttf2pt1
		puts "#"
		puts "# generating type1 version of #{@filename}"
		puts "#"
		pwd = Dir.pwd()
		Dir.chdir($path_ttf)
		command = "ttf2pt1 -a -b #{filename_ttf}"
		puts "> #{command}"
		if system(command) then
			if File.exists?(filename_type1) then
				File.rename(filename_type1, File.join($path_type1, filename_type1))
			else
				stderr.puts "ERROR: '#{filename_type1}' doesn't exist"
			end
			if File.exists?(filename_afm) then
				File.rename(filename_afm, File.join($path_afm, filename_afm))
			else
				stderr.puts "ERROR: '#{filename_afm}' doesn't exist"
			end
		end
		Dir.chdir(pwd)
	end

	def generate_type1
		generate_type1_with_ttf2pt1
	end

	def generate_tfms(encoding)
		# normal
		if is_plus? or encoding.has_bold? then
			generate_tfm(encoding, false)
		end
		# small caps
		if is_plus? and encoding.has_smallcaps? then
			generate_tfm(encoding, true)
		end
	end

	def generate_tfm(encoding, smallcaps)
		pwd = Dir.pwd
		Dir.chdir($path_afm)
		smcp = ""
		if smallcaps then
			smcp = "-sc"
		end
		puts "#"
		puts "# Generating TFM file for font \"#{filename}\" in encoding \"#{encoding.name}#{smcp}\""
		puts "#"
		filename_enc = "gentium-#{encoding.name}#{smcp}.enc"
		filename_map = "#{filename}.map"
		filename_pl_new = "#{encoding.name}-#{filename_tex}#{smcp}.pl"
		filename_tfm    = "#{encoding.name}-#{filename_tex}#{smcp}.tfm"
		filename_lig = File.join(pwd, "lig", "gentium-#{encoding.name}#{smcp}.lig")

		# temporarily copy encoding file to current directory (absolute paths don't seem to work)
		FileUtils.cp(File.join($path_enc, filename_enc), filename_enc)
		# File.copy(File.join($path_enc, filename_enc), filename_enc)
		if File.exists?(filename_lig) then
			command = "afm2pl -p #{filename_enc} -l #{filename_lig} #{filename_afm}"
		else
			command = "afm2pl -p #{filename_enc} #{filename_afm}"
		end
		puts "> #{command}"
		system(command)
		# output = `#{command}`
		# if $?.success? then
			if File.exists?(filename_pl) then
				File.rename(filename_pl, filename_pl_new)
				command2 = "pltotf #{filename_pl_new}"
				puts "> #{command2}"
				if system(command2) then
					if File.exists?(filename_tfm) then
						File.rename(filename_tfm, File.join($path_tfm, filename_tfm))
					else
						$stderr.puts "ERROR: '#{filename_tfm}' doesn't exist"
					end
				else
					$stderr.puts "ERROR: unable to run #{command2}"
				end
			else
				$stderr.puts "ERROR: '#{filename_pl}' doesn't exist"
			end
		# else
		# 	$stderr.puts "ERROR: unable to run '#{command}'"
		# 	puts output
		# end
		File.delete(filename_pl_new)
		File.delete(filename_enc)
		# afm2pl creates filename.map that has to be removed
		File.delete(filename_map)

		Dir.chdir(pwd)
		# puts "   I'm now at #{Dir.pwd}"
	end

	def glyph_names
		if @glyph_names_hash == nil then
			@glyph_names_hash = Hash.new
			File.open(File.join($path_afm, filename_afm)).each_line.grep(/^C .*?; N ([^\s]*)/) do |line|
				name = $1
				@glyph_names_hash[name] = true
				# puts line
			end
		end

		return @glyph_names_hash
	end

	attr_reader :filename, :filename_tex, :name_something
end

class FontSet
	def initialize(font_rm, font_it, font_bf, font_bi)
		@rm = font_rm
		@it = font_it
		@bf = font_bf
		@bi = font_bi
		@list = [font_rm, font_it, font_bf, font_bi]
	end
	def each
		@list.each { |f| if f then yield f end }
	end
end

class Encoding
	def initialize(name, supported_by_basic_family)
		@name = name
		@supported_by_basic_family = supported_by_basic_family
	end
	def to_s
		@name
	end
	def name_context
		return @name
	end
	def name_latex
		if @name == "ec" then
			return "t1"
		elsif @name == "texnansi" then
			return "ly1"
		else
			return @name
		end
	end
	def name_latex_uppercase
		if @name == "l7x" then
			return "L7x"
		else
			return name_latex.upcase
		end
	end
	def name_truetype
		if ["ec", "t5"].include?(@name) then
			return "#{@name}-ttf"
		else
			return @name
		end
	end
	def name_truetype_sc
		if @name == "ec" then
			return "#{@name}-ttf-sc"
		else
			return "#{@name}-sc"
		end
	end

	def is_used_in_context?
		if ["ot1", "ts1", "lgr", "t2b", "t2c", "x2"].include?(@name) then
			return false
		else
			return true
		end
	end
	def is_used_in_latex?
		if ["agr"].include?(@name) then
			return false
		else
			return true
		end
	end
	def has_bold?
		return @supported_by_basic_family
	end
	def has_smallcaps?
		if ["ts1", "agr", "lgr"].include?(@name) then
			return false
		else
			return true
		end
	end

	def generate_enc_sc(font)
		file_enc_new = File.open(File.join($path_enc, "gentium-#{@name}-sc.enc"), 'w')
		File.open(File.join($path_enc, "gentium-#{@name}.enc")).each_line do |line|
			if line =~ /Encoding/ then
				file_enc_new.puts line.gsub(/Encoding/, "scEncoding")
			elsif line =~ /^\/([^\s%]*)/ then
				name = $1
				name_sc = "#{name}.SC"
				if not font.glyph_names[name] then
					puts "Warning: glyph '#{name}' in in encoding '#{@name}' doesn't exist."
				end
				if name == "uni0237" then
					name_sc = "j.SC"
				end
				if font.glyph_names[name_sc] then
					file_enc_new.puts "/#{name_sc}"
				elsif ["ff", "fi", "ffi", "fl", "ffl"].include?(name) then
					file_enc_new.puts "/.notdef"
				else
					file_enc_new.puts "/#{name}"
				end
			else
				file_enc_new.puts line
			end
		end
		file_enc_new.close
	end

	def declare_font_shape(width, shape, name)
		text = "\\DeclareFontShape{#{name_latex_uppercase}}{gentium}{#{width}}{#{shape}}{\n" +
			"            <->     \\gentium@@scale #{@name}-gentium#{name}\n" +
			"}{}\n\n"
		return text
	end
	def declare_font_shape_sub(width1, shape1, width2, shape2)
		return "\\DeclareFontShape{#{name_latex_uppercase}}{gentium}{#{width1}}{#{shape1}}{<->ssub * gentium/#{width2}/#{shape2}}{}"
	end
	def generate_fd
		date = "2012/02/06"
		date = "2011/01/13"

		filename = "#{name_latex}gentium.fd"
		File.open(File.join($path_fd,filename), 'w') do |file|
			file.puts "\\ProvidesFile{#{name_latex}gentium.fd}"
			file.puts "    [#{date} Font definitions for gentium.]"
			file.puts
			file.puts '\expandafter\ifx\csname gentium@scale\endcsname\relax'
			file.puts '    \let\gentium@@scale\@empty'
			file.puts '\else'
			file.puts '    \edef\gentium@@scale{s*[\csname gentium@scale\endcsname]}%'
			file.puts '\fi'
			file.puts
			file.puts "\\DeclareFontFamily{#{name_latex_uppercase}}{gentium}{}"
			file.puts
			file.puts declare_font_shape("m", "n",  "plus-regular")
			file.puts declare_font_shape("m", "it", "plus-italic")
			if has_bold? then
				file.puts declare_font_shape("b", "n",  "basic-bold")
				file.puts declare_font_shape("b", "it", "basic-bolditalic")
				# TODO: set the correct tfm names in the following two lines
				if has_smallcaps? then
					file.puts declare_font_shape("m", "sc",   "plus-regular-sc")
					file.puts declare_font_shape("m", "scit", "plus-italic-sc")
				end
				# TODO: a clever algorithm to do replacements instead
				file.puts declare_font_shape_sub("m",  "sl", "m", "it")
				file.puts declare_font_shape_sub("b",  "sl", "b", "it")
				file.puts declare_font_shape_sub("bx", "sl", "b", "it")
				file.puts declare_font_shape_sub("bx", "it", "b", "it")
				file.puts declare_font_shape_sub("bx", "n",  "b", "n")
			else
				file.puts declare_font_shape_sub("m",  "sl", "m", "it")
			end
			file.puts
			file.puts '\endinput'
		end
	end

	attr_reader :name
end

class EncodingSet < Hash

	def generate_maps(fontlist)
		# initialize lines for map files, one array for each encoding
		map_lines_type1 = Hash.new
		map_lines_ttf   = Hash.new
		self.each_value do |encoding|
			map_lines_type1[encoding.name] = Array.new
			map_lines_ttf[encoding.name]   = Array.new
		end

		# fill data
		fontlist.each do |font|
			self.each_value do |encoding|
				# TODO: fix the last name (gentium) & encodings: this is another parameter that we have to introduce
				name_tfm     = "#{encoding.name}-#{font.filename_tex}".ljust(33)
				line_reenc   = "\"gentium-#{encoding.name}Encoding ReEncodeFont\"".ljust(42)
				name_enc     = "gentium-#{encoding.name}.enc"
				name_enc_ttf = "gentium-#{encoding.name_truetype}.enc"

				# normal
				if font.is_plus? or encoding.has_bold? then
					map_lines_type1[encoding.name].push("#{name_tfm} #{font.name_something.ljust(24)} #{line_reenc} <#{name_enc.ljust(24)} <#{font.filename_type1}")
					map_lines_ttf[encoding.name].push("#{name_tfm} #{font.name_something.ljust(24)} <#{font.filename_ttf.ljust(18)} #{name_enc_ttf}")
				end
				# small caps
				if font.is_plus? and encoding.has_smallcaps? then
					name_tfm    = "#{encoding.name}-#{font.filename_tex}-sc".ljust(33)
					line_reenc = "\"gentium-#{encoding.name}scEncoding ReEncodeFont\"".ljust(42)
					name_enc = "gentium-#{encoding.name}-sc.enc"
					name_enc_ttf = "gentium-#{encoding.name_truetype_sc}.enc"

					map_lines_type1[encoding.name].push("#{name_tfm} #{font.name_something.ljust(24)} #{line_reenc} <#{name_enc.ljust(24)} <#{font.filename_type1}")
					map_lines_ttf[encoding.name].push("#{name_tfm} #{font.name_something.ljust(24)} <#{font.filename_ttf.ljust(18)} #{name_enc_ttf}")
				end
			end
		end

		# write map files into files
		map_file_type1 = File.open(File.join($path_map,     "gentium-type1.map"   ), 'w')
		map_file_ttf   = File.open(File.join($path_map_ttf, "gentium-truetype.map"), 'w')
		self.sort.map do |k,encoding|
			# map file for Type1
			map_lines_type1[encoding.name].each do |line|
				map_file_type1.puts line
			end
			# map file fon TrueType
			map_lines_ttf[encoding.name].each do |line|
				map_file_ttf.puts line
			end
			# map file for TrueType for a single encoding (for ConTeXt)
			# if encoding.is_used_in_context? then
			if true then
				File.open(File.join($path_map_ttf, "gentium-#{encoding.name}.map"), 'w') do |map_file_enc|
					map_lines_ttf[encoding.name].each do |line|
						map_file_enc.puts line
					end
				end
			end
		end
		map_file_type1.close
		map_file_ttf.close
	end
end

