#!/usr/bin/ruby
#Author: Yaniv Ovadia, 110 GTF 11F
#Edited by: Michael Hennessy, 11F

HOST = `echo -n $HOSTNAME`
CLASS = '110'
LOGIN = CLASS

HOME_DIR = `echo -n $HOME`
SUB_DIRS = ["p1", "p2", "p3", "p4", "p5", "examples", "images", "css", "js"]

HT_ACCESS_TXT = \
"AuthUserFile #{HOME_DIR}/htpasswd
AuthGroupFile /dev/null
AuthName \"CIS #{CLASS}\"
AuthType Basic
require user 110"

DIVIDER = '-'*60

DEBUG = false 

require 'pp'

def mkdir(d)
    puts "making directory #{d}"
    if File.exists?(d)
        puts "directory already exists"
    else
        Dir.mkdir(d) if not DEBUG
    end
end

def sh_exec(cmd)
    puts "executing command #{cmd}"
    `#{cmd}`   if not DEBUG
end


def check_host
    if not HOST == "shell.uoregon.edu"
        puts "This program is meant for execution on shell.uoregon.edu. " +\
                "This computer appears to be #{HOST}"
        exit(1)
    end
end

def mk_dir_structure()
    mkdir("#{HOME_DIR}/public_html/#{CLASS}/")
    SUB_DIRS.each do |subdir| 
        mkdir("#{HOME_DIR}/public_html/#{CLASS}/#{subdir}")
    end
end

def mk_htpasswd
    htpasswd_fname = HOME_DIR + "/htpasswd"
    puts "When prompted 'enter a new password', enter the middle three digits of your UO 95 number, then hit Return."
    puts "The digits you type will not be echoed on the screen, for security. \nWhen you have entered the three digits, remember to hit Return."
    puts "You will now be prompted to enter the new password twice ..."
    if File.exists?(htpasswd_fname)
#       puts "htpasswd file already exists, excluding -c flag"
        sh_exec("htpasswd    #{htpasswd_fname} #{LOGIN}")
    else
        sh_exec("htpasswd -c #{htpasswd_fname} #{LOGIN}")
    end
end

def mk_htaccess
    class_dir = "#{HOME_DIR}/public_html/#{CLASS}/"
    htaccess_fname = class_dir + ".htaccess"

    if File.directory?(class_dir)
        puts "Course directory already exists."
    else
        puts "Course directory does not exist yet, creating one..."
        mkdir(class_dir)
    end
    
    if File.exists?(htaccess_fname) 
        puts ".htaccess file already exists, do you wish to replace it? (Y/N)"
        input = gets
        if (input.length < 1) or ( not ['Y','y'].member?(input[0].chr) )
            puts ".htaccess will not be replaced"
            return
        else
            puts ".htaccess will be replaced"
        end
    end
    
    puts "creating .htaccess file with content: "
    puts HT_ACCESS_TXT
    if not DEBUG
        f = File.new(htaccess_fname, 'w')
        f.write(HT_ACCESS_TXT)
        f.close
    end
end


if __FILE__ == $0
    check_host if not DEBUG

    puts "\n", DIVIDER
    puts "First we will complete the directory structure required for this course by adding any required directories that do not yet exist.\n"
    puts "Press enter to continue."
    gets
    
     mk_dir_structure
    
    puts "\n\n", DIVIDER
  puts "Next we will create your HTAccess password to protect your 110 website. \nFor the HTAccess password, use the middle three digits of your UO ID.\nExample: If your UO ID is 950 624 321, your password will be 624."
    puts "Press enter to continue."
    gets
    mk_htpasswd

    puts "\n\n", DIVIDER
    puts "Next we will create the .htaccess file which will implement HTAccess password protection for your 110 website."
    puts "Press enter to continue."
    gets
    mk_htaccess
    
    puts "\n\n", DIVIDER
    puts "Your 110 web directory is now password protected.\n\nWhen you open your 110 website in a web browser you will be prompted for the HTAccess username (110) and the HTAccess password (the middle three digits of your UO 95 number).\n\nNOTE: in your web browser you must enter the complete URL for your 110 site on the server:\n
http://pages.uoregon.edu/yourDuckID/110/\n\nIf you omit 110 from the URL the 110 folder will not appear in your browser."
end
