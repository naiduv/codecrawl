#!/usr/bin/ruby

require 'optparse'
require 'rubygems'
require 'sqlite3'
require "ftools"

g_myname = $0.to_s

g_options = Hash.new
g_optparse = OptionParser.new do |opts|
  opts.banner = "Usage: #{File.basename($0)} [-f config-file] [database-file ...]"
  g_options[:database_file] = ENV['HOME'] + '/.kde/share/apps/kaffeine/sqlite.db'
  g_options[:database_file] = ENV['HOME'] + '/.kde4/share/apps/kaffeine/sqlite.db' \
    if File.readable?(ENV['HOME'] + '/.kde4/share/apps/kaffeine/sqlite.db') \
   and not File.readable?(g_options[:database_file])
  g_options[:config_file] = g_myname.sub(/\.[^.]*$/, '') + ".conf"
  opts.on('-f config-file', String, "Uses the directives in this file.") do |cfg_file|
    g_options[:config_file] = cfg_file
  end
  opts.on_tail('-h', '--help', 'Display this screen') do
    puts opts
    puts "  config-file defaults to: #{g_options[:config_file]} [#{File.readable?(g_options[:config_file]) ? "OK" : "Not readable"}]"
    puts "database-file defaults to: #{g_options[:database_file]} [#{File.readable?(g_options[:database_file]) ? "OK" : "Not readable"}]"
    exit 0
  end
end

begin
  g_optparse.parse!(ARGV)
rescue OptionParser::ParseError
  $stderr.print "Error: #{$!}\n"
  puts g_optparse.to_s
  exit 3
end


# Define a class to hold a channel, with some extra information.
class Channel
  attr_accessor :id, :number, :name, :db_row

  def tv?
    @flags == 1
  end

  def stored?
    @stored
  end

  def name_changed?
    @b_name_set
  end

  def number_changed?
    @b_number_set
  end

  def set_stored
    @stored = true
  end

  def set_number(number)
    if @number != number then
      @number = number
      @db_row[2] = number
      @b_number_set = true
    end
  end

  def set_name(name)
    if @name != name then
      @name = name
      @db_row[1] = name
      @b_name_set = true
    end
  end

  def initialize(db_row)
    @db_row = db_row
    @id = db_row[0].to_i
    @name = db_row[1].to_s
    @number = db_row[2].to_i
    @flags = db_row[10].to_i
    @stored = false
    @b_number_set = false
    @b_name_set = false
  end
end


g_channels = Array.new
g_channels_to_remove = Array.new
g_regex_removal_expressions = Array.new
g_rename_expressions = Hash.new
g_rename_expressions_reverse = Hash.new

g_radio_channels = Array.new
g_radio_channels_to_remove = Array.new
g_radio_regex_removal_expressions = Array.new
g_radio_rename_expressions = Hash.new
g_radio_rename_expressions_reverse = Hash.new

puts "1. Read config-file ..."
if File.readable?(g_options[:config_file]) then
  puts "  Open config-file: #{g_options[:config_file]}"
  File.open(g_options[:config_file], "r") do |cfg_file|
    cfg_file.each_line do |line|
      line.chomp!
      unless line.empty? then
        case line
          when /^\+\|(.+)/
            g_channels.push($1)
          when /^-\|(.+)/
            g_channels_to_remove.push($1)
          when /^R\|(.+)/
            g_regex_removal_expressions.push($1)
          when /^r\|(.+)\|(.+)/
            g_rename_expressions[$1] = $2
            g_rename_expressions_reverse[$2] = $1
          when /^!\+\|(.+)/
            g_radio_channels.push($1)
          when /^!-\|(.+)/
            g_radio_channels_to_remove.push($1)
          when /^!R\|(.+)/
            g_radio_regex_removal_expressions.push($1)
          when /^!r\|(.+)\|(.+)/
            g_radio_rename_expressions[$1] = $2
            g_radio_rename_expressions_reverse[$2] = $1
        end
      end
    end
  end
  puts "  Number of TV-channels to store: #{g_channels.length}"
  puts "  Number of TV-channels to remove: #{g_channels_to_remove.length}"
  puts "  Number regexp removeal expressions (TV): #{g_regex_removal_expressions.length}"
  puts "  Number rename expressions (TV): #{g_rename_expressions.length}"
  puts "  Number of radio-channels to store: #{g_radio_channels.length}"
  puts "  Number of radio-channels to remove: #{g_radio_channels_to_remove.length}"
  puts "  Number regexp removeal expressions (Radio): #{g_radio_regex_removal_expressions.length}"
else
  $stderr.print "Error: Cannot read config-file: #{g_options[:config_file]}\n"
  exit 1
end

ARGV.push(g_options[:database_file]) if ARGV.empty?
ARGV.each do |db_file|
  puts "2. Read database-file ..."
  backup_file = File.basename(db_file) + "~" + Time.now.strftime('%Y%m%d-%H%M%S')
  puts "  Backup database to: #{backup_file}"
  File.copy(db_file, backup_file)
  puts "  Open database: #{db_file}"
  begin
    db = SQLite3::Database.open(db_file)
    tv_channels = 0
    other_channels = 0
    n_removed_by_name = 0
    n_removed_by_regexp = 0
    n_radio_removed_by_name = 0
    n_radio_removed_by_regexp = 0
    a_channels = Array.new
    a_channels_to_remove = Array.new
    db.execute("select Id, Name, Number, Source, Transponder, NetworkId, \
                       TransportStreamId, PmtPid, PmtSection, AudioPid, Flags \
                  from Channels") do |row|
      b_add_flag = true
      channel = Channel.new(row)
      if channel.tv? then
        tv_channels += 1
        # Handle removal of TV-channels.
        if g_channels_to_remove.index(channel.name) then
          b_add_flag = false
          n_removed_by_name += 1
        end
        if b_add_flag then
          g_regex_removal_expressions.each do |regexp|
            if channel.name =~ /#{regexp}/ then
              b_add_flag = false
              n_removed_by_regexp += 1
              break
            end
          end
        end
      else
        other_channels += 1
        # Handle removal of other (radio) channels.
        if g_radio_channels_to_remove.index(channel.name) then
          b_add_flag = false
          n_radio_removed_by_name += 1
        end
        if b_add_flag then
          g_radio_regex_removal_expressions.each do |regexp|
            if channel.name =~ /#{regexp}/ then
              b_add_flag = false
              n_radio_removed_by_regexp += 1
              break
            end
          end
        end
      end
      if b_add_flag then
        a_channels.push(channel)
      else
        # Collect channels to remove.
        a_channels_to_remove.push(channel)
      end
    end
    # Create new channel-list.
    a_new_channel_list = Array.new
    # 1. Handle all wanted TV-channels.
    g_channels.each do |wanted_channel_name|
      a_channels.each do |channel|
        if (channel.name == wanted_channel_name \
            or g_rename_expressions_reverse[channel.name] == wanted_channel_name) \
       and channel.tv? and not channel.stored? then
          a_new_channel_list.push(channel)
          channel.set_stored
        end
      end
    end
    # 2. Handle all wanted radio-channels.
    g_radio_channels.each do |wanted_channel_name|
      a_channels.each do |channel|
        if (channel.name == wanted_channel_name \
            or g_radio_rename_expressions_reverse[channel.name] == wanted_channel_name) \
       and not channel.tv? and not channel.stored? then
          a_new_channel_list.push(channel)
          channel.set_stored
        end
      end
    end
    # 3. Handle all remaining TV-channels.
    a_channels.each do |channel|
      if channel.tv? and not channel.stored? then
        a_new_channel_list.push(channel)
        channel.set_stored
      end
    end
    # 4. Handle all remaining channels (radio).
    a_channels.each do |channel|
      if not channel.stored? then
        a_new_channel_list.push(channel)
        channel.set_stored
      end
    end
    # 5. Rename and renumber all new channels.
    n_renamed_channels = 0
    n_renamed_radio_channels = 0
    n_id = 0
    a_new_channel_list.each do |channel|
      n_id += 1
      channel.set_number(n_id)
      if channel.tv? then
        g_rename_expressions.each do |s_from, s_to|
          if channel.name == s_from then
            puts "  > Rename [TV] '#{s_from}' to '#{s_to}'"
            a_new_channel_list.each do |channel2|
              if channel2.name == s_to then
                channel2.set_name(channel2.name + ' (renamed)')
              end
            end
            channel.set_name(s_to)
            n_renamed_channels += 1
            break
          end
        end
      else
        g_radio_rename_expressions.each do |s_from, s_to|
          if channel.name == s_from then
            puts "  > Rename [Radio] '#{s_from}' to '#{s_to}'"
            a_new_channel_list.each do |channel2|
              if channel2.name == s_to then
                channel2.set_name(channel2.name + ' (renamed)')
              end
            end
            channel.set_name(s_to)
            n_renamed_radio_channels += 1
            break
          end
        end
      end
    end
    puts "  Total number of TV-channels: #{tv_channels}"
    puts "  Total number of Radio-channels: #{other_channels}"
    # Write data back to database.
    puts "3. Write database file ..."
    # puts "  Remove all channels from DB ..."
    # db.execute("delete from Channels")
    puts "  Delete all unwanted channels ..."
    n_id = 0
    a_channels_to_remove.each do |channel|
      n_id += 1
      db.execute("delete from Channels where Number = ?", channel.number)
      $stdout.print "  Delete channel #{n_id}/#{a_channels_to_remove.length}\r"
      $stdout.flush
    end
    puts if a_channels_to_remove.length > 0
    puts "  Update database file ..."
    n_new_tv_channels = 0
    n_new_radio_channels = 0
    n_id = 0
    n_updates = 0
    a_new_channel_list.each do |channel|
      b_update_flag = false
      n_id += 1
      if channel.number_changed? and channel.name_changed? then
        db.execute("update Channels set Number = ?, Name = ? where Id = ?",
          channel.number, channel.name, channel.id)
        b_update_flag = true
      elsif channel.name_changed? then
        db.execute("update Channels set Name = ? where Id = ?",
          channel.name, channel.id)
        b_update_flag = true
      elsif channel.number_changed? then
        db.execute("update Channels set Number = ? where Id = ?",
          channel.number, channel.id)
        b_update_flag = true
      end
      if b_update_flag then
        n_updates += 1
        $stdout.print "  Update channel #{n_id}/#{a_new_channel_list.length}\r"
        $stdout.flush
      end
      if channel.tv? then
        n_new_tv_channels += 1
      else
        n_new_radio_channels += 1
      end
    end
    puts if n_updates > 0
    #
    puts "  Number of written channels: #{a_new_channel_list.length}"
    puts "  Number of written TV-channels: #{n_new_tv_channels}"
    puts "  Number of removed TV-channels (by name): #{n_removed_by_name}"
    puts "  Number of removed TV-channels (by regexp): #{n_removed_by_regexp}"
    puts "  Number of renamed TV-channels: #{n_renamed_channels}"
    puts "  Number of written radio-channels: #{n_new_radio_channels}"
    puts "  Number of removed radio-channels (by name): #{n_radio_removed_by_name}"
    puts "  Number of removed radio-channels (by regexp): #{n_radio_removed_by_regexp}"
    puts "  Number of renamed radio-channels: #{n_renamed_radio_channels}"
    # Close database.
    db.close unless db.closed?
  rescue => e
    db.close unless db.closed?
    $stderr.print "Error: #{e.to_s}\n"
    exit 1
  end
end
