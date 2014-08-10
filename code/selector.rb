
unexist@73: #!/usr/bin/ruby
unexist@73: #
unexist@73: # @file Selector
unexist@73: #
unexist@73: # @copyright (c) 2011, Christoph Kappel <unexist@dorfelite.net>
unexist@73: # @version $Id$
unexist@73: #
unexist@73: # Client selector that works like the subscription selector in google reader
unexist@73: #
unexist@73: # Colors:
unexist@73: #
unexist@74: # Focus    - Currently selected client
unexist@73: # Occupied - Visible clients on current views
unexist@74: # View     - Currently not visible clients
unexist@73: #
unexist@73: # Keys:
unexist@73: #
unexist@77: # Left, Up          - Move to left
unexist@77: # Right, Down       - Move to right
unexist@77: # Tab               - Cycle through windows/matches
unexist@77: # Escape            - Leave input mode/exit selector
unexist@77: # Return            - Focus currently selected and hide/exit selector
unexist@77: # Any capital/digit - Select client prefixed with capital letter/digit
unexist@77: # Any text          - Select client with matching instance name
unexist@73: #
unexist@73: # http://subforge.org/wiki/subtle-contrib/Wiki#Selector
unexist@73: #
unexist@73: 
unexist@73: require "singleton"
unexist@73: 
unexist@73: begin
unexist@76:   require "subtle/subtlext"
unexist@73: rescue LoadError
unexist@73:   puts ">>> ERROR: Couldn't find subtlext"
unexist@73:   exit
unexist@73: end
unexist@73: 
unexist@73: # Check for subtlext version
unexist@73: major, minor, teeny = Subtlext::VERSION.split(".").map(&:to_i)
unexist@77: if(major == 0 and minor == 9 and 2577 > teeny)
unexist@79:   puts ">>> ERROR: selector needs at least subtle `0.9.2577' (found: %s)" % [
unexist@79:     Subtlext::VERSION
unexist@73:    ]
unexist@73:   exit
unexist@73: end
unexist@73: 
unexist@73: # Launcher class
unexist@73: module Subtle # {{{
unexist@73:   module Contrib # {{{
unexist@73:     class Selector # {{{
unexist@73:       include Singleton
unexist@73: 
unexist@77:       # Prefix letters
unexist@77:       LETTERS = ((49..57).to_a|(65..89).to_a).map(&:chr)
unexist@77: 
unexist@73:       # Default values
unexist@73:       @@font = "-*-*-medium-*-*-*-14-*-*-*-*-*-*-*"
unexist@73: 
unexist@73:       # Singleton methods
unexist@73: 
unexist@73:       ## fonts {{{
unexist@73:       # Set font strings
unexist@73:       # @param [String]  fonts  Fonts array
unexist@73:       ##
unexist@73: 
unexist@73:       def self.font=(font)
unexist@73:         @@font = font
unexist@73:       end # }}}
unexist@73: 
unexist@73:       ## run {{{
unexist@73:       # Run expose
unexist@73:       ##
unexist@73: 
unexist@73:       def self.run
unexist@73:         self.instance.run
unexist@73:       end # }}}
unexist@73: 
unexist@73:       # Instance methods
unexist@73: 
unexist@73:       ## initialize {{{
unexist@73:       # Create expose instance
unexist@73:       ##
unexist@73: 
unexist@73:       def initialize
unexist@77:         # Values
unexist@77:         @colors   = Subtlext::Subtle.colors
unexist@77:         @wins     = []
unexist@77:         @expanded = false
unexist@77:         @buffer   = ""
unexist@77:         @x        = 0
unexist@77:         @y        = 0
unexist@77:         @width    = 0
unexist@77:         @height   = 0
unexist@73: 
unexist@73:         # Create main window
unexist@73:         @win = Subtlext::Window.new(:x => 0, :y => 0, :width => 1, :height => 1) do |w|
unexist@73:           w.name        = "Selector"
unexist@73:           w.font        = @@font
unexist@77:           w.foreground  = @colors[:title_fg]
unexist@77:           w.background  = @colors[:title_bg]
unexist@73:           w.border_size = 0
unexist@73:         end
unexist@73: 
unexist@73:         # Font metrics
unexist@73:         @font_height = @win.font_height + 6
unexist@73:         @font_y      = @win.font_y
unexist@73:       end # }}}
unexist@73: 
unexist@77:       ## run {{{
unexist@77:       # Show and run launcher
unexist@77:       ##
unexist@77: 
unexist@77:       def run
unexist@77:         update
unexist@77:         arrange
unexist@77:         recolor
unexist@77:         show
unexist@77: 
unexist@77:         @buffer = ""
unexist@77: 
unexist@77:         # Listen to key press events
unexist@77:         @win.listen do |key|
unexist@77:           ret = true
unexist@77: 
unexist@77:           case key
unexist@77:             when :left, :up # {{{
unexist@77:               idx       = @clients.index(@current)
unexist@77:               idx      -= 1 if(0 < idx)
unexist@77:               @current  = @clients[idx]
unexist@77: 
unexist@77:               recolor # }}}
unexist@77:             when :right, :down # {{{
unexist@77:               idx       = @clients.index(@current)
unexist@77:               idx      += 1 if(idx < (@clients.size - 1))
unexist@77:               @current  = @clients[idx]
unexist@77: 
unexist@77:               recolor # }}}
unexist@77:             when :return # {{{
unexist@77:               @current.focus
unexist@77: 
unexist@77:               ret = false # }}}
unexist@77:             when :escape # {{{
unexist@77:               if(@expanded)
unexist@77:                 @buffer = ""
unexist@77:                 expand
unexist@77:               else
unexist@77:                 ret = false
unexist@77:               end # }}}
unexist@77:             when :backspace # {{{
unexist@77:               if(@expanded)
unexist@77:                 @buffer.chop!
unexist@77:                 @win.write(2, @height - @font_height + @font_y + 3, "Input: %s" % [ @buffer ])
unexist@77:                 @win.redraw
unexist@77:                 expand
unexist@77:               end # }}}
unexist@77:             when :tab # {{{
unexist@77:               if(@buffer.empty?)
unexist@77:                 clients = @clients
unexist@77:               else
unexist@77:                 # Select matching clients
unexist@77:                 clients = @clients.select do |c|
unexist@77:                   c.instance.downcase.start_with?(@buffer)
unexist@77:                 end
unexist@77:               end
unexist@77: 
unexist@77:               unless((idx = clients.index(@current)).nil?)
unexist@77:                 # Cycle between clients
unexist@77:                 if(idx < (clients.size - 1))
unexist@77:                   idx += 1
unexist@77:                 else
unexist@77:                   idx = 0
unexist@77:                 end
unexist@77: 
unexist@77:                 @current = clients[idx]
unexist@77: 
unexist@77:                 recolor
unexist@77:               end # }}}
unexist@77:             else
unexist@77:               str = key.to_s
unexist@77: 
unexist@77:               if(!(idx = LETTERS.index(str)).nil? and idx < @clients.size)
unexist@77:                 @clients[idx].focus
unexist@77: 
unexist@77:                 ret = false
unexist@77:               elsif(!str.empty?)
unexist@77:                 @buffer << str.downcase
unexist@77: 
unexist@77:                 @clients.each do |c|
unexist@77:                   if(c.instance.downcase.start_with?(@buffer))
unexist@77:                     @current = c
unexist@77:                     recolor
unexist@77: 
unexist@77:                     break
unexist@77:                   end
unexist@77:                 end
unexist@77: 
unexist@77:                 expand
unexist@78:                 @win.write(6, @height - @font_height + @font_y + 3, "Input: %s" % [ @buffer ])
unexist@77:                 @win.redraw
unexist@77:               end
unexist@77:           end
unexist@77: 
unexist@77:           ret
unexist@77:         end
unexist@77: 
unexist@77:         hide
unexist@77:       end # }}}
unexist@77: 
unexist@77:       private
unexist@77: 
unexist@73:       ## update # {{{
unexist@73:       # Update clients and windows
unexist@73:       ##
unexist@73: 
unexist@73:       def update
unexist@73:         @clients = Subtlext::Client.all
unexist@73:         @visible = Subtlext::Client.visible
unexist@73:         @current = Subtlext::Client.current
unexist@73: 
unexist@73:         # Check window count
unexist@73:         if(@clients.size > @wins.size)
unexist@73:           (@clients.size - @wins.size).times do |i|
unexist@73:             @wins << @win.subwindow(:x => 0, :y => 0, :width => 1, :height => 1) do |w|
unexist@73:               w.name        = "Selector client"
unexist@73:               w.font        = @@font
unexist@73:               w.foreground  = @colors[:views_fg]
unexist@73:               w.background  = @colors[:views_bg]
unexist@73:               w.border_size = 0
unexist@73:             end
unexist@73:           end
unexist@73:         end
unexist@73:       end # }}}
unexist@73: 
unexist@73:       ## arrange {{{
unexist@73:       # Move expose windows to current screen
unexist@73:       ##
unexist@73: 
unexist@73:       def arrange
unexist@77:         geo     = Subtlext::Screen.current.geometry
unexist@77:         @width  = geo.width * 50 / 100 #< Max width
unexist@77:         @height = @font_height
unexist@77:         wx      = 0
unexist@77:         wy      = 0
unexist@77:         len     = 0
unexist@77:         wwidth  = 0
unexist@73: 
unexist@73:         # Arrange client windows
unexist@73:         @clients.each_with_index do |c, i|
unexist@73:           w   = @wins[i]
unexist@77:           len = w.write(6, @font_y + 3, "%s:%s" % [
unexist@77:             LETTERS[i], c.instance ]
unexist@77:           ) + 6
unexist@73: 
unexist@73:           # Wrap lines
unexist@77:           if(wx + len > @width)
unexist@77:             wwidth  = wx if(wx > wwidth)
unexist@77:             wx      = 0
unexist@77:             wy     += @font_height
unexist@73:           end
unexist@73: 
unexist@73:           w.geometry = [ wx, wy, len, @font_height ]
unexist@73: 
unexist@73:           wx += len
unexist@73:         end
unexist@73: 
unexist@77:         # Update geometries
unexist@77:         @width   = 0 == wwidth ? wx : wwidth
unexist@77:         @height += wy
unexist@77:         @x       = geo.x + ((geo.width - @width) / 2)
unexist@77:         @y       = geo.y + ((geo.height - @height) / 2)
unexist@73: 
unexist@77:         @win.geometry = [ @x , @y, @width, @height ]
unexist@77:       end # }}}
unexist@73: 
unexist@77:       ## expand {{{
unexist@77:       # Expand selector
unexist@77:       ##
unexist@77: 
unexist@77:       def expand
unexist@77:         if(@buffer.empty? and @expanded)
unexist@77:           @height   -= @font_height
unexist@77:           @expanded  = false
unexist@77: 
unexist@77:           @win.geometry = [ @x , @y, @width, @height ]
unexist@77:         elsif(!@expanded)
unexist@77:           @height   += @font_height
unexist@77:           @expanded  = true
unexist@77: 
unexist@77:           @win.geometry = [ @x , @y, @width, @height ]
unexist@77:         end
unexist@73:       end # }}}
unexist@73: 
unexist@73:       ## recolor {{{
unexist@73:       # Update colors of subwindos
unexist@73:       ##
unexist@73: 
unexist@73:       def recolor
unexist@73:         @wins.each_with_index do |w, i|
unexist@73:           # Highlight current and visible clients
unexist@73:           if(@clients[i] == @current)
unexist@73:             w.foreground = @colors[:focus_fg]
unexist@73:             w.background = @colors[:focus_bg]
unexist@73:           elsif(@visible.include?(@clients[i]))
unexist@73:             w.foreground = @colors[:occupied_fg]
unexist@73:             w.background = @colors[:occupied_bg]
unexist@73:           else
unexist@73:             w.foreground = @colors[:views_fg]
unexist@73:             w.background = @colors[:views_bg]
unexist@73:           end
unexist@73: 
unexist@73:           w.redraw
unexist@73:         end
unexist@73:       end # }}}
unexist@73: 
unexist@73:       ## show {{{
unexist@73:       # Show launcher
unexist@73:       ##
unexist@73: 
unexist@73:       def show
unexist@73:         @win.show
unexist@73: 
unexist@73:         # Show used windows only
unexist@73:         @wins.each_with_index do |w, i|
unexist@73:           w.show if(i < @clients.size)
unexist@73:         end
unexist@73:       end # }}}
unexist@73: 
unexist@73:       ## hide # {{{
unexist@73:       # Hide launcher
unexist@73:       ##
unexist@73: 
unexist@73:       def hide
unexist@73:         @win.hide
unexist@73:         @wins.map(&:hide)
unexist@73:       end # }}}
unexist@73: 
unexist@73:     end # }}}
unexist@73:   end # }}}
unexist@73: end # }}}
unexist@73: 
unexist@73: # Implicitly run
unexist@73: if(__FILE__ == $0)
unexist@73:   # Set font
unexist@73:   #Subtle::Contrib::Selector.font =
unexist@73:   # "xft:DejaVu Sans Mono:pixelsize=80:antialias=true"
unexist@73: 
unexist@73:   Subtle::Contrib::Selector.run
unexist@73: end
unexist@77: 
unexist@77: # vim:ts=2:bs=2:sw=2:et:fdm=marker




