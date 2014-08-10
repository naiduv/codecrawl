#!/usr/bin/ruby
#
#     Author :	David Billsbrough <kc4zvw@earthlink.net>
#    Created :	Tue Apr 11 01:13:41 EDT 2006
#    License :	GNU General Public License -- version 2
#    Version :	$Revision: 0.55 $
#   Warranty :	None
#
#    Purpose :	Convert an Juno address book for the LDIF format.
#
#   $Id: juno2ldif.rb,v 0.55 2006/04/15 11:15:34 kc4zvw Exp kc4zvw $ 
#
###----------------------------------------------------------###

class AddressBook

	attr_accessor :name, :email, :alias, :first, :last
	attr_reader   :name, :email, :alias, :first, :last
	attr_writer   :name, :email, :alias, :first, :last

	def initialize
		self.clear
	end

	def clear
		@name = nil
		@email = nil
		@alias = nil
	end
end

###----------------------------------------------------------###

""" Retrieve System Info """

def get_home_dir
	myHOME = ENV["HOME"]
	print "My $HOME directory is #{myHOME}.\n"
	return myHOME
end

def get_timestamp
	""" Timestamp Format: YYYYMMDDHHMMSSZ """
	tm = Time.now

	return sprintf("%04d%02d%02d%02d%02d%02dZ",
		tm.year, tm.mon, tm.mday, tm.hour, tm.min, tm.sec) end

###----------------------------------------------------------###

def get_firstname (name, pos)
	return name[pos + 2, 99]
end

def get_lastname (name, pos)
	return name[0, pos]
end

def get_fullname (first_name, last_name)
	return "#{first_name} #{last_name}"
end

def swap_name(name)

	pos = name.index(',') if name != nil

	if pos != nil
		first = get_firstname(name, pos)
		last = get_lastname(name, pos)
	end

	return first, last
end

###----------------------------------------------------------###

def display_entry (nickname, name, email)
	puts "Converting \"#{name}\" ..."
	puts "  #{nickname} is #{email}"
	puts
end

def write_ldif_entry (output, addressbook)

	""" Output a LDIF record """

	email = addressbook.email
	firstname = addressbook.first
	lastname = addressbook.last
	myalias = addressbook.alias
	timestamp = get_timestamp
	fullname = get_fullname(firstname, lastname)

	output.puts "dn: cn=#{fullname},mail=#{email}"
	output.puts "cn: #{fullname}"
	output.puts "sn: #{lastname}"
	output.puts "givenname: #{firstname}"
	output.puts "objectclass: top"
	output.puts "objectclass: person"
	output.puts "mail: #{email}"
	output.puts "xmozillausehtmlmail: FALSE"
	output.puts "xmozillauseconferenceserver: 0"
	output.puts "modifytimestamp: #{timestamp}"
	output.puts "xmozillanickname: #{myalias}"
	output.puts ""
end

###----------------------------------------------------------###

def process_line(aline, address_book, output)

	line = aline.chop!

	case line
		when "Type:Version"
			# do nothing
			return
		when "Version:AB 0.2.0"
			# do nothing
			return
		when ""
			#print "Blank Line\n"
			address_book.clear
		when "Type:Entry"
			#print "Found new entry\n"
			return
		when /Name:*/
			address_book.name = line[5,99]
		when /Email:*/
			address_book.email = line[6,99]
		when /Alias:*/
			address_book.alias = line[6,99]
	end

	#p address_book

	if address_book.alias != nil then
		first, last = swap_name(address_book.name)
		fullname = get_fullname(first, last)
		address_book.first = first
		address_book.last = last
		myalias = address_book.alias
		email = address_book.email

		display_entry(myalias, fullname, email)		# display progress
		write_ldif_entry(output, address_book)		# write LDIF entry
	end
end

### ------------------------ Main routine ------------------------ ###

""" Initialize Objects """

myBook = AddressBook.new()

home = get_home_dir

juno_path = [ home, "addrbook.nv" ]
ldif_path = [ home, "addresses.ldif" ]

juno = juno_path.join("/")
ldif = ldif_path.join("/")

puts
puts "The Juno mail address file is #{juno}."
puts "The LDIF output file is #{ldif}."
puts

begin
	input = File.new(juno, mode='r')
rescue
	print "Couldn't open #{juno} for reading addresses.\n"
	exit 1
end

begin
	output = File.new(ldif, mode='w')
rescue
	print "Couldn't open #{ldif} for writing addresses.\n"
	exit 2
end

for aline in input.readlines()
	process_line(aline, myBook, output)
end

input.close
output.close

puts
system 'date +"Converted on %x at %r."'
puts
puts "Finished."

# End of Script
