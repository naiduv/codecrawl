#! /usr/local/bin/ruby 
#
# H" ‚Ì CSVŒ`Ž®‚Ì“d˜b’ ‚ð vCard ‚É•ÏŠ·‚·‚é
#
# % ruby csv-vcard.rb phonebook.csv
#
# Copyright (C) 2001 Satoru Takabayashi <satoru@namazu.org> 
#     All rights reserved.
#     This is free software with ABSOLUTELY NO WARRANTY.
#
# You can redistribute it and/or modify it under the terms of 
# the GNU General Public License version 2.
#

$KCODE = 's'

class Array
  def xpush (item)
    self.push(item) unless item.empty?
  end
end

class VCard
  def initialize
    @name  = nil
    @yomi  = nil
    @tels  = []
    @mails = []
    instance_variables.each {|name|
      type.class_eval { attr_accessor name.delete '@' }
    }
  end

  def to_s
    buf = []
    buf.push("BEGIN:VCARD")
    buf.push("VERSION:3.0")
    buf.push("FN:#{@name}")
    buf.push("N:#{@name}")
    buf.push("SORT-STRING:#{@yomi}")

    pref = 'PREF,'
    @tels.each {|tel|
      if /^0[789]0/ =~ tel
	buf.push("TEL;TYPE=#{pref}CELL:#{tel}")
      else
	buf.push("TEL;TYPE=#{pref}VOICE:#{tel}")
      end
      pref = ''
    }

    pref = 'PREF,'
    @mails.each {|mail|
      if /[@.](docomo|pdx|ezweb|jp-[a-z])\.ne\.jp/ =~ mail
	buf.push("EMAIL;TYPE=#{pref}CELL:#{mail}")
      else
	buf.push("EMAIL;TYPE=#{pref}INTERNET:#{mail}")
      end
      pref = ''
    }
    buf.push("CLASS:PUBLIC")
    buf.push("END:VCARD")
    buf.join("\n")
  end
end

def parse_line (line)
  items = line.split(',')

  vcard = VCard.new
  vcard.name = items[2]
  vcard.yomi = items[3]

  vcard.tels.xpush(items[4])
  vcard.tels.xpush(items[5])
  vcard.tels.xpush(items[6])

  vcard.mails.xpush(items[9])
  vcard.mails.xpush(items[10])
  return vcard
end

def main
  readlines.each_with_index {|line, i|
    vcard = parse_line(line)
    File.open("#{i}.vcf", 'w') {|f| 
      f.puts vcard
    }
  }
end

main
