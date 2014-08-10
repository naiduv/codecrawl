#!/usr/bin/env ruby

#
# This program produces barplots from the output of STRUCTURE's command line version.
#
# 2008-06-11                   Michael Matschiner <michaelmatschiner@mac.com>
#
#
# This script complements the command line version of STRUCTURE (Pritchard, 
# Stephens, and Donelli (2000)) by producing vector graphic barplots based on
# the command line version output. The only necessary parameter is the name
# of the input file, and the script can be started by typing:
# ruby bar_plotter.rb -i inputfilename
#
# The script accepts LF, CR, and CRLF line endings. The output is written in
# scalable vector graphics (SVG) format, always with LF line endings.
#


# Class "Array2" is used to build a two-dimensional matrix which stores the 
# inferred ancestry of individuals, as calculated by STRUCTURE.
#
class Array2
  def initialize
    @store = [[]]
  end
  def [](a,b)
    if @store[a]==nil ||
      @store[a][b]==nil
      return nil
    else
      return @store[a][b]
    end
  end
  def []=(a,b,x)
    @store[a] = [] if @store[a]==nil
    @store[a][b] = x
  end
end


# The method to_s() is added to class Float for economical output. This way,
# the number of decimals included in floats can be chosen.
class Float
  alias_method :orig_to_s, :to_s
  def to_s(arg = nil)
    if arg.nil?
      orig_to_s
    else
      sprintf("%.#{arg}f", self)
    end
  end
end



# The main program starts here. A number of default values is set.
progName = "bar_plotter.rb"
vertTicks = false
vertLines = false
colorFile = false
gradient = false
dimX = 800
dimY = 400
strokeWidth = 1.0
vertLinesWidth = 0.5
knownColors = ["aqua", "black", "blue", "fuchsia", "gray", "green", "lime", "maroon", "navy", "olive", "purple", "red", "silver", "teal", "white", "yellow"]


# The input file is the first command line argument. It is specified by
# -i input_file_name .
#
if ARGV.size < 2
  puts "ERROR: no input file specified!"
  puts "usage: ruby #{progName} -i filename [-c colorlist -g gradient_color -v vertical_lines_color -t ticklength]"
  exit
end
unless ARGV.include?("-i")
  puts "ERROR: no input file specified!"
  puts "usage: ruby #{progName} -i filename [-c colorlist -g gradient_color -v vertical_lines_color -t ticklength]"
  exit
end
if ARGV[ARGV.index("-i")+1] == nil or ARGV[ARGV.index("-i")+1][0..0] == "-"
  puts "ERROR: no input file specified!"
  puts "usage: ruby #{progName} -i filename [-c colorlist -g gradient_color -v vertical_lines_color -t ticklength]"
  exit
end
fileIn = ARGV[ARGV.index("-i")+1]


# A color list file can be specified by -c color_list_file_name .
# If no color list file is specified, greyscale colors will be used
#
if ARGV.include?("-c") and ARGV[ARGV.index("-c")+1] != nil
  colorFileName = ARGV[ARGV.index("-c")+1]
  if colorFileName[0..0] == "-"
    puts "ERROR: Option -c is used but no color file name given"
    exit
  end
end


# A gradient can be applied on top of the barplot, by adding the option
# -g , followed by a color in common or hex format.
# E.g. -g 808080 will apply the same gradient as -g gray .
# If only -g is given, but not followed by a color, the default (gray)
# is used.
#
if ARGV.include?("-g") and ARGV[ARGV.index("-g")+1] != nil
  gradient = true
  gradColor = ARGV[ARGV.index("-g")+1]
  if gradColor[0..0] == "-"
    gradColor = "gray"
  elsif gradColor.scan(/[a-f0-9]{6}/).to_s != ""
    gradColor = "\#" + gradColor
  elsif knownColors.include?(gradColor.chomp) == false
    puts "WARNING: gradient color may not be a valid SVP color!"
  end
elsif ARGV.include?("-g") and ARGV[ARGV.index("-g")+1] == nil
  gradient = true
  gradColor = "gray"
end


# Black ticks can be added at the top and at the bottom of the barplot
# between every column. This option is specified by -t, followed by the
# length of the ticks in pixels:
# -t 5 .
# If only -t is specified, but not length value, the default (3) is used.
#
if ARGV.include?("-t") and ARGV[ARGV.index("-t")+1] != nil
  vertTicks = true
  if ARGV[ARGV.index("-t")+1][0..0] == "-"
    vertTickLength = 3
  else
    vertTickLength = ARGV[ARGV.index("-t")+1].to_i
  end
elsif ARGV.include?("-t") and ARGV[ARGV.index("-t")+1] == nil
  vertTicks = true
  vertTickLength = 3
end


# Vertical lines can be added between every column, to better distinguish
# individuals. This can be done by adding the -v option, followed by a color:
# -v ff0000 or -v red .
# If only -v is specified, but no color, the default (gray) is used.
#
if ARGV.include?("-v") and ARGV[ARGV.index("-v")+1] != nil
  vertLines = true
  vertLineColor = ARGV[ARGV.index("-v")+1]
  if vertLineColor[0..0] == "-"
    vertLineColor = "gray"
  elsif vertLineColor.scan(/[a-f0-9]{6}/).to_s != ""
    vertLineColor = "\#" + vertLineColor
  elsif knownColors.include?(vertLineColor.chomp) == false
    puts "WARNING: vertical line color may not be a valid SVP color!"
  end
elsif ARGV.include?("-v") and ARGV[ARGV.index("-v")+1] == nil
  vertLines = true
  vertLineColor = "gray"
end


# The input file is read as a single string. Line endings are detected,
# and used to split the string into an array of strings.
#
str = IO.read( fileIn )
if str.include?("\r\n")
  ary = str.split("\r\n")
elsif str.include?("\r")
  ary = str.split(/\r/) if str.include?("\r")
elsif str.include?("\n")
  ary = str.split(/\n/) if str.include?("\n")
else
  puts "ERROR: input file does not contain linebreaks!"
  exit
end


# The first lines (those before the relevant table) are deleted from
# the array.
#
ary.shift until ary[0].include?("Inferred ancestry of individuals:")
ary.shift
ary.shift

# The last lines (after the relevant table) are deleted.
#
tail = false
ary.size.times do |x|
  tail = true if ary[x].include?("Estimated Allele Frequencies in each cluster")
  ary[x] = "\n" if tail
end
ary.delete_if { |x| x == "\n"}
ary.delete_if { |x| x == ""}


# The dimensions of the table is detected.
#
rowNum = ary.size
colNum = ary[0].strip.split(/\s+/).size

mat = Array2.new
rowNum.times do |r|
  ary[r].strip!
  tmp = ary[r].split(/\s+/)
  colNum.times do |c|
      mat[r,c] = tmp[c]
  end
end


# From the dimensions of the table, and the population assignment values
# in column 4, the number of assigned populations and inferred clusters 
# are determined.
#
popNum = 1
(rowNum-1).times do |r|
  popNum += 1 if mat[r,3].to_i < mat[r+1,3].to_i
end
clustNum = colNum-5


# The colorspace is taken from the color list file. If no color list file
# is specified, greyscale is used as the colorspace. If a color list file
# is specified, but does not contain enough color values, the given color
# values are complemented with greyscale values.
#
colors = Array.new
if colorFileName == nil
  colors << "000000"
  1.upto(clustNum-1) do |c|
    tmp = (((c/(clustNum-1).to_f)*256.0).round)-1
    hex = tmp.to_s(16)
    colors << "#{hex}#{hex}#{hex}"
  end
else
  colorStr = IO.read( colorFileName )
  if colorStr.include?("\r\n")
    colors = colorStr.split("\r\n")
  elsif colorStr.include?("\r")
    colors = colorStr.split("\r")
  elsif colorStr.include?("\n")
    colors = colorStr.split("\n")
  else
    puts "ERROR: color file does not contain linebreaks!"
    exit
  end
  colors.each{ |x| x.chomp!}
  colors.each{ |x| x.delete!("\#") }
  if colors.size < clustNum
    diff = clustNum-colors.size
    if diff == 1
      colors << "000000"
    elsif diff == 2
      colors << "000000"
      colors << "ffffff"
    else
      colors << "000000"
      1.upto(diff-1) do |c|
        tmp = (((c/(diff-1).to_f)*256.0).round)-1
        hex = tmp.to_s(16)
        colors << "#{hex}#{hex}#{hex}"
      end
    end
  end
end


# The SVG output is prepared.
#
svgOutput = String.new
svgOutput << "<?xml version=\"1.0\" standalone=\"no\"?>\n"
svgOutput << "<!DOCTYPE svg PUBLIC \"-//W3C//DTD SVG 1.0//EN\" \"http://www.w3.org/TR/2001/REC-SVG-20010904/DTD/svg10.dtd\">\n"
svgOutput << "<svg xmlns=\"http://www.w3.org/2000/svg\" width=\"#{dimX}\" height=\"#{dimY}\" viewBox=\"0 0 #{dimX} #{dimY}\"\n"
svgOutput << "  xmlns:xlink=\"htttp://www.w3.org/1999/xlink\">\n\n"
svgOutput << "<!--created with #{progName}-->\n"
svgOutput << "\n<defs>\n"
if gradient
  svgOutput << "  <linearGradient id=\"grad_1\"\n"
  svgOutput << "    x1=\"0\" y1=\"1\" x2=\"0\" y2=\"0\" >\n"
  svgOutput << "    <stop offset=\"0\" stop-color=\"#555555\" />\n"
  svgOutput << "    <stop offset=\"1\" stop-color=\"#000000\" />\n"
  svgOutput << "  </linearGradient>\n"
  svgOutput << "  <mask id=\"mask_1\"><rect fill=\"url(\#grad_1)\" x=\"#{strokeWidth/2.0}\" y=\"#{strokeWidth/2.0}\" width=\"#{dimX-strokeWidth}\" height=\"#{dimY-strokeWidth}\" /></mask>\n"
end
svgOutput << "</defs>\n"
svgOutput << "\n\n"


svgOutput << "<!--Bars-->\n"
rowNum.times do |r|
  sum = 0.0
  all = 0.0
  clustNum.times do |c|
    all += mat[r,c+5].to_f
  end
  clustNum.times do |c|
    svgOutput << "<rect style=\"fill:\##{colors[c]}\" x=\"#{((dimX-2*strokeWidth+vertLinesWidth)*((r).to_f/rowNum.to_f)+strokeWidth-vertLinesWidth/2.0).to_s(2)}\" y=\"#{(strokeWidth+sum*(dimY-2*strokeWidth)*(1.0/all)).to_s(2)}\" width=\"#{((dimX-2*strokeWidth)/rowNum).to_s(2)}\" height=\"#{(((dimY-2*strokeWidth)*mat[r,c+5].to_f)*(1.0/all)).to_s(2)}\" />\n"
    sum += mat[r,c+5].to_f
  end
end
svgOutput << "\n\n"


svgOutput << "<!--Vertical lines between populations-->\n"
(rowNum-1).times do |r|
  if mat[r,3].to_i < mat[r+1,3].to_i
    svgOutput << "<line id=\"#{r+1}\" style=\"stroke:\#000000; stroke-width:#{vertLinesWidth}px\" x1=\"#{((dimX-2*strokeWidth+vertLinesWidth)*((r+1).to_f/rowNum.to_f)+strokeWidth-vertLinesWidth/2.0).to_s(2)}\" y1=\"#{strokeWidth}\" x2=\"#{((dimX-2*strokeWidth+vertLinesWidth)*((r+1).to_f/rowNum.to_f)+strokeWidth-vertLinesWidth/2.0).to_s(2)}\" y2=\"#{dimY-strokeWidth}\"/>\n"
  end
end  
svgOutput << "\n\n"


if vertLines
  svgOutput << "<!--Vertical lines between individuals-->\n"
  (rowNum-1).times do |r|
    unless mat[r,3].to_i < mat[r+1,3].to_i
      svgOutput << "<line id=\"#{r+1}v\" style=\"stroke:#{vertLineColor}; stroke-width:#{vertLinesWidth}px\" x1=\"#{(dimX-2*strokeWidth+vertLinesWidth)*((r+1).to_f/rowNum.to_f)+strokeWidth-vertLinesWidth/2.0}\" y1=\"#{strokeWidth}\" x2=\"#{(dimX-2*strokeWidth+vertLinesWidth)*((r+1).to_f/rowNum.to_f)+strokeWidth-vertLinesWidth/2.0}\" y2=\"#{dimY-strokeWidth}\"/>\n"
    end
  end
  svgOutput << "\n\n"
end


if vertTicks
  svgOutput << "<!--Vertical ticks between individuals-->\n"
  (rowNum-1).times do |r|
    unless mat[r,3].to_i < mat[r+1,3].to_i
      svgOutput << "<line id=\"#{r+1}o\" style=\"stroke:\#000000; stroke-width:#{vertLinesWidth}px\" x1=\"#{((dimX-2*strokeWidth+vertLinesWidth)*((r+1).to_f/rowNum.to_f)+strokeWidth-vertLinesWidth/2.0).to_s(2)}\" y1=\"#{strokeWidth}\" x2=\"#{((dimX-2*strokeWidth+vertLinesWidth)*((r+1).to_f/rowNum.to_f)+strokeWidth-vertLinesWidth/2.0).to_s(2)}\" y2=\"#{strokeWidth+vertTickLength}\"/>\n"
      svgOutput << "<line id=\"#{r+1}u\" style=\"stroke:\#000000; stroke-width:#{vertLinesWidth}px\" x1=\"#{((dimX-2*strokeWidth+vertLinesWidth)*((r+1).to_f/rowNum.to_f)+strokeWidth-vertLinesWidth/2.0).to_s(2)}\" y1=\"#{dimY-strokeWidth-vertTickLength}\" x2=\"#{((dimX-2*strokeWidth+vertLinesWidth)*((r+1).to_f/rowNum.to_f)+strokeWidth-vertLinesWidth/2.0).to_s(2)}\" y2=\"#{dimY-strokeWidth}\"/>\n"
    end
  end
  svgOutput << "\n\n"
end


svgOutput << "<!--Frame-->\n"
svgOutput << "<rect style=\"stroke:black; stroke-width:#{strokeWidth}px; fill:none\" x=\"#{strokeWidth/2.0}\" y=\"#{strokeWidth/2.0}\" width=\"#{dimX-strokeWidth}\" height=\"#{dimY-strokeWidth}\" />\n"
svgOutput << "\n\n"

if gradient
  svgOutput << "<!--Rectangle on which is a mask with gradient-->\n"
  svgOutput << "<rect fill=\"#{gradColor}\" x=\"#{strokeWidth}\" y=\"#{strokeWidth}\" width=\"#{dimX-2*strokeWidth}\" height=\"#{dimY-2*strokeWidth}\" mask=\"url(\#mask_1)\" />\n"
  svgOutput << "\n\n"
end

svgOutput << "</svg>"



# The string "output" is written to a new file with the same name as the input file,
# but with "_barplot.svg" added to the name.
#
fileOutName = fileIn.scan(/\w+./)[0].chomp(".") + "_barplot" + ".svg"
fileOut = File.new(fileOutName, "w")
fileOut.print svgOutput.to_s
puts "STRUCTURE barplot written to \"#{fileOutName}\""
