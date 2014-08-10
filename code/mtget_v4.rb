#!/usr/bin/ruby
# Helper script for the zdf mediathek.
# v 0.4.01 <apoc@sixserv.org>
# the old v3: http://apoc.sixserv.org/scripts/mtget_v3.rb

require 'rubygems'
require 'mechanize' # install with: gem install mechanize --remote
require 'json' # install json with: gem install json --remote
require 'iconv'
require 'getoptlong'
require 'cgi'

$agent = WWW::Mechanize.new

aQuality = ['isdn', 'dsl1000', 'dsl2000']
aFormat = ['qtp', 'wmp', 'jwflv'] # 'real' == crap

CMD_VIEW_STRINGS = {
  'qtp' => 'vlc %url%',
  'wmp' => 'mplayer -fs -display :0.0 -prefer-ipv4 -cache 2000 "%url%"',
  'jwflv' => 'echo "%url%"'
}

CMD_DOWNLOAD_STRINGS = {
  # qtp/quicktime uses rtsp streaming
  'qtp' => 'mplayer -noframedrop -dumpfile %outfile% -dumpstream %url%',

  # wmp/wmv using mms streaming could ripped via mplayer OR mmsrip OR ...
  'wmp' => 'mmsrip "--output=%outfile%" %url%',
  #'wmp' => 'mplayer -noframedrop -dumpfile %outfile% -dumpstream %url%',

  # jwflv/flash video uses rtmp streaming, could downloaded via 
  #'jwflv' => './rtmpdump -r %url% -o %outfile%'
  'jwflv' => 'echo "%url%"'
}

# default settings:
$quality = 'dsl2000'
$format = 'wmp'
$mode = 'view'
search = nil
inter = false # interactive mode
$verbose = false

MAX_SEARCH = 25

# trap("INT") { `reset`; exit }

def help
puts <<EOS
Helper script for the zdf mediathek.
(c) 2009 apoc <apoc@sixserv.org>

Syntax: #{$1} <URL/id> [Options]

  <URL/id>                   mediathek url or id of category or single video
  -q, --quality <quality>    change quality settings: isdn, dsl1000, dsl2000
  -f, --format <format>      change format settings: qtp, wmp or jwflv
  -m, --mode <mode>          'view' or 'download'
                             change shell commands in script(!)
  -s, --search <topic>       search inside the mediathek and view/download the result
  -i, --inter                interactive: select videos to play
  -v, --verbose              verbose output
  -h, --help                 show this help message

EOS
end
opts = GetoptLong.new(
  ['--quality', '-q', GetoptLong::OPTIONAL_ARGUMENT],
  ['--format', '-f', GetoptLong::OPTIONAL_ARGUMENT],
  ['--mode', '-m', GetoptLong::OPTIONAL_ARGUMENT],
  ['--search', '-s', GetoptLong::OPTIONAL_ARGUMENT],
  ['--inter', '-i', GetoptLong::OPTIONAL_ARGUMENT],
  ['--verbose', '-v', GetoptLong::OPTIONAL_ARGUMENT],
  ['--help', '-h', GetoptLong::OPTIONAL_ARGUMENT]
)

opts.each do |opt, arg|
  case opt
    when '--quality'
      if not aQuality.include? arg
        puts 'wrong quality setting'
        exit
      end
      $quality = arg
    when '--format'
      if not aFormat.include? arg
        puts 'wrong format setting'
        exit
      end
      $format = arg
    when '--mode'
      if arg != 'view' and arg != 'download'
        puts 'wrong mode setting'
        exit
      end
      $mode = arg
    when '--search'
      if arg.empty?
        puts "empty search?!"
        exit
      end
      search = arg
    when '--inter'
      inter = true
    when '--verbose'
      $verbose = true
    when '--help'
      help
      exit
  end
end

if ARGV.length < 1 and search == nil
help
exit
end

def get_mt_id(url)
  puts " [+] Try to retrieve id: #{url}" if $verbose
  id = nil

  url = url.gsub /\?.*$/, ''

  # search for id
  if url.match /^[0-9]+$/
    id = url.to_i
  else
    # matching url structure?
    if url.match /\/([0-9]+)$/
      id = $1
    else
      # search inside page
      page = $agent.get url
      if page.body.match /<input type="text" value="http:\/\/www\.zdf\.de\/ZDFmediathek\/content\/([^"]+)" \/>/
        $1.match /\/([0-9]+)$/
        id = $1
      end
    end
  end
  puts " [+] Found ID: #{id}" if $verbose

  id
end

def get_asset_url(id)
  puts " [+] Try to find asset url(s) for id: #{id}" if $verbose
  begin
    page = $agent.get "http://www.zdf.de/ZDFmediathek/content/#{id}?bw=#{$quality}&pp=#{$format}&view=navJson"
  rescue
    puts " [E] Error in fetching json url" if $verbose
    return nil
  end

  title = '<unknown>'
  asset = JSON.parse(page.body)
  if asset.has_key? 'assetTitle'
    tmp_title = asset['assetTitle']
    begin
      tmp_title = Iconv.conv('ISO-8859-1', 'utf-8', tmp_title)
      tmp_title.gsub! /&[^;]+;/, ''
    rescue
      puts ' [E] ivonv error' if $verbose
    end

    puts " [+] Found title: #{tmp_title}" if $verbose
    title = tmp_title if not tmp_title.empty?
  end

  if page.body.match /g_availableStream\.#{$format} = \{([^\}]+)\}/
    if $1.match /#{$quality}:false/
      puts " [E] Format/Quality not availible for this Video." if $verbose
      return nil
    end
  end

  if asset.has_key? 'assetUrl'
    puts " [+] Found assetUrl: #{asset['assetUrl']}" if $verbose
    return [ [title, asset['assetUrl']] ]
  else
    puts " [+] Video category found" if $verbose
    asset_urls = []
    mm = page.body.scan /href=\\"\/ZDFmediathek\/content\/[^\/]+\/[^\/]+\/([0-9]+)\\">/
    mm.uniq!
    mm.each do |m|
      asset = get_asset_url(m)
      asset.flatten! if asset != nil
      asset_urls << asset
    end
    if asset_urls == nil
      return nil
    elsif asset_urls.length == 0
      return nil
    else
      return asset_urls
    end
  end
end

def get_video_links(asset_urls)
  video_links = []
  puts " [+] Searching video url(s)..." if $verbose
  asset_urls.each do |title, url|
    next if url == nil
    if url.match /flashFile/
      puts " [E] Ignore interactive Flash content" if $verbose
    elsif url.match /meta$/
      meta = $agent.get url
      if meta.body.match /url>([^<]+)</
        video_links << [title, $1]
      else
        puts " [E] Error in parsing meta file." if $verbose
      end
    elsif url.match /asx$/
      asx = $agent.get url
      if asx.body.match /href="([^"]+)"/
        video_links << [title, $1]
      else
        puts " [E] Error in parsing asx!" if $verbose
      end
    elsif url.match /mov$/
      mov = $agent.get url
      if mov.body.match /\n([^\n]+)\n/
        video_links << [title, $1]
      else
        puts " [E] Error in parsing mov reference file." if $verbose
      end
    else
      puts " [E] Error: Unknown assetUrl: #{url}" if $verbose
    end
  end

  video_links.each_index do |i|

    if video_links[i][1].empty?
      video_links.delete_at i
    end
  end

  return video_links
end

# TODO: das geht ja nun wirklich auch eleganter...
def userselect_vids(video_links)
  puts 
  puts "Found the following videos:"
  video_links.each_index do |i|
    puts " [#{i}] #{video_links[i][0]}"
  end
  puts

  invalid = true
  while invalid
    print " [?] List videos by ids(space seperated!): "
    list = $stdin.gets.chomp
    
    a = list.split(' ')
    invalid = false if a.length > 0
    a.each do |i|
      if i.match /^[0-9]+$/
        invalid = true if i.to_i >= video_links.length or i.to_i < 0
      else
        invalid = true
      end
    end
  end

  new_video_links = []
  a.each do |i|
    new_video_links << video_links.at(i.to_i)
  end
  new_video_links
end

def view_or_download(url)
  puts " [+] View/Download: #{url}" if $verbose
  if $mode == 'view'
    cmd = CMD_VIEW_STRINGS[$format]
  else
    cmd = CMD_DOWNLOAD_STRINGS[$format]
  end

  url.match /\/([^\/]+)$/
  filename = $1

  cmd = cmd.gsub /%url%/, url
  cmd = cmd.gsub /%outfile%/, filename

  puts " [+] execute: #{cmd}" if $verbose

  # TODO: problem bei INT 
  system(cmd)
  #`#{cmd} &> /dev/null` möglich, siehe auch den trap teil
end



# searching...
if search != nil
  puts " [+] Searching for: '#{search}'" if $verbose

  search_url = 'http://www.zdf.de/ZDFmediathek/search'
  search_url += "?searchStr=#{CGI.escape search}"
  search_url += '&orderBy=searchsendedatum&offset=0'
  search_url += '&sortDirection=descending&docTypeInteraktiv=false'
  search_url += '&docTypeBilderserie=false&docTypeVideo=true&view=navJson'

  page = $agent.get search_url
  mm = page.body.scan /href=\\"(\/ZDFmediathek\/content\/[^\\]+)\\"/
  mm.uniq!
  
  cnt = 0
  video_links = []
  mm.each do |m|
    murl = "http://www.zdf.de#{m[0]}"
    puts " [+] Try found URL: #{murl}" if $verbose

    id = get_mt_id murl
    next if id == nil

    asset_urls = get_asset_url id
    next if asset_urls == nil or asset_urls.length <= 0

    links = get_video_links(asset_urls).flatten
    video_links += [links] if links.length > 0

    cnt += 1
    break if cnt > MAX_SEARCH
  end

  if video_links.empty?
    puts " [+] Nothing found"
    puts
    exit
  end

  if inter
    video_links = userselect_vids video_links
  end


  video_links.each do |title, url|
    view_or_download url
  end


  puts " [+] Finished searching"
  exit
end

# normal
url = ARGV.shift
id = get_mt_id url
if id == nil
  puts 'Could not find Mediathek-Id' if $verbose
  exit
end

asset_urls = get_asset_url id

if asset_urls == nil
  puts " [+] no asset url(s) found"
  exit
end
video_links = get_video_links asset_urls
video_links.uniq!

if inter
  video_links = userselect_vids video_links
end

video_links.each do |title, url|
  view_or_download url
end
