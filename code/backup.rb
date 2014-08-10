# 3-23-2009 -- Version 3
# Copyright (C) 2009 Gabriel Eggleston
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

################################################
# As the dialog text below says, this script requires wxruby and robocopy
# to be installed. Robocopy is bundled with Windows Vista or newer,
# and if you have Windows XP then you can install it from the
# Windows 2003 Resource Kit.
################################################

require 'wx'

DEBUG=false

SCRIPT_VERSION="v.3"

ERROR_USER_CANCEL=1
ERROR_NO_DIRECTORY_CHOSEN=2
EXIT_SUCCESS=0

class BackupApp < Wx::App
	def on_init
		if !File::exists?( "#{ENV['USERPROFILE']}/.norobosplash")
			splash = Wx::MessageDialog.new(nil, "This backup script will use "+
				"the \"robocopy\" utility to copy a "+
				"directory and all of its subdirectories in backup mode "+
				"(ignoring permissions), and will continue on any error. "+
				"\n\nThis script requires Ruby, wxRuby2, and "+
				"(of course) robocopy. (If you can see this dialog box, "+
				"you already have the first two). It must be run as an " +
				"Administrator or a user with backup permissions." +
				"\n\nTo make this dialog stop appearing, place a file "+
				"named \".norobosplash\" in your user profile directory ("+
				"C:\\Documents and Settings\\username\\ or "+
				"C:\\Users\\username\\).", "Introduction")
			
			if splash.show_modal == Wx::ID_CANCEL
				exit(ERROR_USER_CANCEL)
			end
		end	# if no .norobosplash
		
		num_dlg = Wx::SingleChoiceDialog.new(nil,
			"How many directories do you want to copy?",
			"Number to copy",
			:n => 10,
			:choices => ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"] )
		if num_dlg.show_modal == Wx::ID_OK
			num_dirs = num_dlg.get_selection+1
		else
			exit(ERROR_USER_CANCEL)
		end
		
		sources = Array.new( num_dirs )
		num_dirs.times { |i|
			src_dlg = Wx::DirDialog.new(nil, "Choose a source directory (#{SCRIPT_VERSION})")
			

			if src_dlg.show_modal == Wx::ID_OK
				sources[i] = src_dlg.get_path
			else
				exit(ERROR_NO_DIRECTORY_CHOSEN)	
			end

		}
		
		dest_dlg = Wx::DirDialog.new(nil, "Choose a destination directory")
		if dest_dlg.show_modal == Wx::ID_OK
			destination = dest_dlg.get_path
		else
			exit(ERROR_NO_DIRECTORY_CHOSEN)
		end
		
		if DEBUG
			num_dirs.times { |i|
				puts i.to_s + ":\n"
				puts "From: \"" + sources[i] + "\"\n"
				puts "To: \"" + destination + "\"\n"
				puts "----------\n"
			}
		end
		
		num_dirs.times { |i|
			progress = Wx::ProgressDialog.new("Working...",
				"Copying from #{sources[i]} to #{destination}...")
			progress.pulse
			system("robocopy /ZB /E /R:0 \"#{sources[i]}\" \"#{destination}\"") unless DEBUG
			progress.destroy
		}
		exit (EXIT_SUCCESS)
	end
end

BackupApp.new.main_loop
