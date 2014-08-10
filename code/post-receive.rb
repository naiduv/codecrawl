#!/usr/bin/env ruby

require 'rubygems'
require 'grit'
require 'mcollective'

include MCollective::RPC

@matched_modules = []
@matched_nodes = []
@matched_facts = []

# turns fqdns in to my mcollective identities
def hostname(fqdn)
  return fqdn if fqdn == "devco.net"
  fqdn.split(".").first
end

# my hiera hierarchy is based on facts and fqdn, parse
# that and add them to the filter arrays
def parse_hiera(path)
  if path == "hieradb/common.json"
    @matched_modules << "common::monitor"
  elsif path =~ /hieradb\/(.+?)_(.+).json/
    @matched_facts << "#{$1}=#{$2}"
  elsif path =~ /^([\S\.]+).json/
    @matched_nodes << hostname($1)
  end
end

# parse node files
def parse_node(path)
  @matched_nodes << hostname($1) if path =~ /nodes\/([\S\.]+).pp/
end

# Parse module paths, I have some special cases here
#
#  * files/snippets/fqdn.something - these are node specific files
#  * files/zones/some.domain       - these are for my bind::master
#
# In cases where I dont have the above matches in templates, files
# or lib I just match all nodes /modulename/
def parse_modules(path)
  parts = path.split("/")
  modname = parts[2]
  type = parts[3]
  module_parts = parts[4..-1]

  case type
    when "files", "templates", "lib"
      if module_parts[0] == "snippets"
        @matched_nodes << hostname(module_parts[1])
      elsif module_parts[0] == "zones"
        @matched_modules << "bind::master"
      else
        @matched_modules << "/#{modname}/"
      end
    when "manifests"
      if parts[-1] == "init.pp"
        @matched_modules << modname
      else
        @matched_modules << [modname, module_parts].flatten.join("::").gsub(/\.pp$/, "")
      end
    else
      puts "ERROR: Do not know how to parse module file #{path}"
  end
end

while msg = gets
  old_sha, new_sha, ref = msg.split(' ', 3)

  repo = Grit::Repo.new(File.join(File.dirname(__FILE__), '..'))

  commit = repo.commit(new_sha)

  case ref
    when %r{^refs/heads/(.*)$}
      branch = $~[1]
      if branch == "master"
        puts "Commit on #{branch}"
        commit.diffs.each do |diff|
          puts "    %s" % diff.b_path

          case diff.b_path
            when /^hieradb/
              parse_hiera(diff.b_path)
            when /^nodes/
              parse_node(diff.b_path)
            when /^common\/modules/
              parse_modules(diff.b_path)
            else
              puts "ERROR: Do not know how to parse #{diff.b_path}"
          end
        end
      else
        puts "Commit on non master branch #{branch} ignoring"
      end
  end
end

unless @matched_modules.empty? && @matched_nodes.empty? && @matched_facts.empty?
  puppet = rpcclient("puppetd")

  nodes = []
  compound_filter = []

  nodes << @matched_nodes

  # if classes or facts are found then do a discover
  unless @matched_modules.empty? && @matched_facts.empty?
    compound_filter << @matched_modules << @matched_facts

    puppet.comound_filter compound_filter.flatten.uniq.join(" or ")

    nodes << puppet.discover
  end

  if nodes.flatten.uniq.empty?
    puts "No nodes discovered via mcollective or in commits"
    exit
  end

  # use new mc 2.0.0 pluggable discovery to supply node list
  # thats a combination of data discovered on the network and file named
  puppet.discover :nodes => nodes.flatten.uniq

  puts
  puts "Files matched classes: %s" % @matched_modules.join(", ") unless @matched_modules.empty?
  puts "Files matched nodes: %s" % @matched_nodes.join(", ") unless @matched_nodes.empty?
  puts "Files matched facts: %s" % @matched_facts.join(", ") unless @matched_facts.empty?
  puts
  puts "Triggering puppet runs on the following nodes:"
  puts
  puppet.discover.in_groups_of(3) do |nodes|
    puts "   %-20s %-20s %-20s" % nodes
  end

  puppet.runonce

  printrpcstats
else
  puts "ERROR: Could not determine a list of nodes to run"
end
