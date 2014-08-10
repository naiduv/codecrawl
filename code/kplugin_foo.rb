=begin

 AUTHOR:
  Kesiev <http://www.kesiev.com>
  
 WHAT IT DOES:
  Nothing. It just shows some plugin functions, putting stuff
  around.

=end
# Do something when a plugin is loaded
puts "loading plugin..."

# Adding items to the side list
$lists << {
	# Entry label
	:label=>"Sample plugin",
	
	# Entry icon
	:icon=>"stock_midi",
	
	# Put :protected to true if the list is not user editable
	:protected => false,
	
	# This prefix is always added before the file name when an item
	# of this playlist is opened. This part is not needed into the
	# backend file. Is also automatically prepended to the file name
	# when an item is copied to an not protected playlist.
	:root=>"",
	
	# every side list item has a backend file that can be generated
	# in different moments
	:file=>"#{$opt[:root]}/sampleplugin",

	# this is done when refreshing. You can make your backendfile here,
	# as into this example
	:onrefreshask=>"Wanna refresh?",
	:onrefresh=>Proc.new{ |f| sampleplugin_makecontent(f) },
	
	# this is done when selecting the item and usually the playlist
	# on screen is updated. The playlist is made reading the backend
	# file, so, if isn't already there, we will try to create it.
	# You can do it into the refresh event, if you want.
	:onclick => Proc.new { |f| sampleplugin_makecontent(f) if !File.exist?(f[:file]);  :update },
	# remember to returns the :update symbol. If you want to call the
	# updatesongs method manually (or you want to call something else)
	# return the :noupdate symbol instead.
	
}

# Is suggested do make e content creator that you can call when is asked
# a refresh or on opening the playlist each time (or cache content)
def sampleplugin_makecontent(section)
	puts "#{section[:label]} is updating the playlist."
	open(section[:file],"w") { |f|
		3.times { |track_no|
			track_url="http://www.google.it/search?q=Track#{track_no}"
			mplayer_item="cdda://#{track_no+1}"
			artist=""
			# Each line is formed like this. Pick your data everywhere 
			# you like ;)
			f.puts([artist,"Album title",track_no,"Track name (#{track_no})",track_url,mplayer_item].join($opt[:separator]))
		}
		f.puts(["KesieV","My Bookmarks",0,"You can make bookmarks omitting the mplayer item","http://www.kesiev.com",""].join($opt[:separator]))
	}
	puts "#{section[:label]} has updated his list."
end

# This method is called each time the player recives meta or changes
# state
alias sampleplugin_notify notify
def notify(me)
	# Calls the original method (and other plugins)
	sampleplugin_notify(me)	
	# And then does something custom...
	me.state.each_with_index { |i,idx| puts "State #{idx} is #{i}" }
	puts "Song: #{me.meta[0]}"
	puts "Artist: #{me.meta[1]}"
	puts "Album: #{me.meta[2]}"
	# NOTE: $covername is updated ONLY AFTER calling the original
	# method!
	puts "Cover: #{$covername}"
	puts "----"
end

# This method is called when Kesiev Chiefs is closing
alias sampleplugin_shutdown shutdown
def shutdown
	# This is done before system stuff is shutted down
	puts "See you soon by the sample plugin!"
	# Now shut down system things
	sampleplugin_shutdown
	# Done at very last!
	puts "Have a nice day!"
end

# Adding an item on an existing menu
$menus << {
	:menu=>:song, 
	:label=>"Sample plugin",
	:action=>Proc.new{ puts "Sample plugin triggered by a menu!"}
}

# Adding a custom menu.
$menulist << { :label => "Sample plugin", :id=>:sampleplugin }
# And let's add some options...
3.times { |i|
	$menus << {
		:menu=>:sampleplugin, 
		:label=>"Sample plugin option #{i}",
		:action=>Proc.new{ puts "Sample plugin triggered by option #{i}!"}
	}
}

# Adding a custom icon into the toolbar
$toolbar << 
	# A button...
	{
		# Icon to be used
		:icon=>Gtk::Stock::EXECUTE,
		# What to do on click
		:action=>Proc.new{ puts "Sample plugin custom toolbar button."}
	} <<
	# ...and a separator.
	{:sep=>1}
	
# Adding a contextual action for items on playlist
$contextactions << {
	# The button's id. Can reference the button object with
	# $toolbaritems[<this id>]
	:id => :sampleplugin,
	# The action's label
	:label => "Sample plugin action",
	# The condition of showing. In this example we are checking the
	# a current section attribute and the current selected item column.
	# This option is only shown on the item into the "Sample plugin"
	# with track number = 2.
	:verifyer => Proc.new{ |s| $section[:label]=="Sample plugin" && s[3]==2 },
	# What to do on click?
	# In this example, will be dumped the current selection attributes
	:action => Proc.new{ |s| $COLMAP.length.times { |i| puts "#{i}=#{s[i]}" } }	
}

# This is called when implicit functions are added to user playlists.
# It is useful for making user-definable playlists handled by
# plugins. User can define lists using "lists.<attribute>" in their
# config file. <attribute>  can be what you want so you can use it for
# sending parameters to plugins, create multiple hinstances or marking
# custom lists to be used by your plugin.
alias sampleplugin_generateimplicits generateimplicits
def generateimplicits
	# Calling the original generateimplicits function
	sampleplugin_generateimplicits
	# Here we can process the $lists array and change some parameters
	# before starting the program. We will try, for example, to change
	# the label and icon of the "Music" entry.
	$lists.length.times { |i|
		if $lists[i][:label]=="Music" then
			$lists[i][:label]="My Cool music"
			$lists[i][:icon]="apple-red"
		end
	}
	
end

# This is called when an item is played. By default, URLs without
# song are opened into the browser, else the related mplayer url is
# played. We can play a bit before executing the default action - or
# skip that action, if you want to do something else. You can, for
# example, add GIF support and open it with the "display" command.
# Remember that mplayer urls have to be prefixed with $section[:root]
# value, which is different for each plugin.
# The "display" command is usually into the imagemagick package but you
# can choose something else instead.
alias sampleplugin_play play
def play(iter)
	# We are handling gif extensions, so we will check it
	if File.extname(iter[5]).downcase==".gif" then
		# If is OK, let's display the image. Watch out, this is just a
		# test. Filenames should be quoted and etc.
		fork {`display "#{$section[:root].to_s+iter[5]}"`}
		# If you want, you can go to the next song automatically and
		# leave this to the background. Else, after action, playback
		# is stopped.
		nextsong
	else
		# If we're not handling this url, we'll send back to other
		# plugins or the main action. It will be played the next track
		# automatically after playback, if played by mplayer.
		sampleplugin_play(iter)
	end
end
