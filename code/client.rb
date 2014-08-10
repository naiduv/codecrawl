#!/usr/bin/env ruby

class JsonGooseClient

require 'rubygems'
require 'json'
require 'net/http'
require 'uri'
require 'getoptlong'
require 'pp'






def self.post_request(json)
    @HOST = "localhost"
    @PORT = "9010"
    @CONTEXT = "JSON-RPC"






    @urlstring = "http://#{@HOST}:#{@PORT}/#{@CONTEXT}"
    @url = URI.parse(@urlstring)



    Net::HTTP.start(@HOST, @PORT) do |http|
        response = http.post("/#{@CONTEXT}", json)
        #puts "Code = #{response.code}"
        #puts "Message = #{response.message}"
        #response.each {|key, val| printf "%-14s = %-40.40s\n", key, val }
        #p response.body[400, 55]
        #puts response.body
        #puts response.to_s
        response.body
    end
end

def self.usage()
    print <<EOF

JsonGoose command-line client.
Full documentation at:
http://gaggle.systemsbiology.net/wiki/doku.php?id=json_script_goose

command-line switches:
--name/-n name: specify a name for the broadcast
--species/-s:   specify a species name for the broadcast
--target/-t:    specify the name of a goose to broadcast to
--file/-f filename: gets input from filename or standard input if filename is "-"
--execute/-e:   executes arbitrary JSON-RPC code contained in file specified by --file/-f flag
--getgoosename: gets the name of this goose
--getgoosenames:    gets names of all geese, including this one
--hide: hides target goose (specified by --target/-t flag)
--show: shows target goose (specified by --target/-t flag)        
--showjson shows JSON received
--quit: quits the Script Goose
--getmethodnames:   gets a list of methods which can be called via JSON-RPC
--broadcast:    broadcasts the payload specified by the --file/-f flag
--getbroadcast: gets latest broadcast received, or waits for broadcast
--suppressmetadata: suppresses metadata lines (starting with #) at beginning of broadcast output
--help: prints this help message
EOF
end

def self.parse_options()
    opts = GetoptLong.new(
            ["--name", "-n", GetoptLong::REQUIRED_ARGUMENT],
            ["--species", "-s", GetoptLong::REQUIRED_ARGUMENT],
            ["--target", "-t", GetoptLong::REQUIRED_ARGUMENT],
            ["--file", "-f", GetoptLong::REQUIRED_ARGUMENT],
            ["--getgoosename", GetoptLong::NO_ARGUMENT],
            ["--getgoosenames", GetoptLong::NO_ARGUMENT],
            ["--hide", GetoptLong::NO_ARGUMENT],
            ["--show", GetoptLong::NO_ARGUMENT],
            ["--quit", "-q", GetoptLong::NO_ARGUMENT],
            ["--execute", "-e", GetoptLong::NO_ARGUMENT],
            ["--help", GetoptLong::NO_ARGUMENT],
            ["--broadcast", "-b", GetoptLong::NO_ARGUMENT],
            ["--getbroadcast", "-g", GetoptLong::NO_ARGUMENT],
            ["--suppressmetadata", GetoptLong::NO_ARGUMENT],
            ["--getmethodnames", GetoptLong::NO_ARGUMENT],
            ["--showjson", GetoptLong::NO_ARGUMENT]
            

    )
end

#def self.clean_arg(arg)
#    arg.gsub!(%Q("), "")
#end

def self.get_file_contents()
    filename = @options['--file']
    if (filename == '-')
        $stdin.read
    else
        IO.readlines(filename).join("")
    end
end

def self.call_goose_method(name, args)
    call_rmi_method("goose", name, args)
end

def self.call_boss_method(name, args)
    call_rmi_method("boss", name, args)
end

def self.call_rmi_method(classs, name, args)
    h = {}
    h[:id] = 1
    h[:method] = "#{classs}.#{name}"
    h[:params] = args
    #puts "about to send this json:\n#{h.to_json}\n\n"
    result =  post_request(h.to_json)
    #puts "got this result:\n#{result}\n\n"
    get_method_result(result)
end

def self.get_method_result(json)
    h = JSON.parse(json)
    h['result']
end

def self.do_broadcast()
    payload = get_file_contents()

    #try to determine what kind of broadcast it is
    if (payload !~ /\{/ and payload !~ /\t/)
        #puts "looks like a namelist"
        broadcast_namelist(payload)
    elsif (payload !~ /\{/ and payload.split("\n").size == 2)
        # this could actually trap a matrix with one line of data but that seems unlikely
        #puts "looks like a cluster
        broadcast_cluster(payload)
    elsif (payload != /\{/ and payload =~ /\t/)
        #puts "looks like a matrix"
        broadcast_matrix(payload)
    elsif (payload =~ /\{/)
        #puts "looks like a network"
        broadcast_network(payload)
    end
end

def self.broadcast_network(payload)
    params = []
    params.push @target
    network = JSON.parse(payload) # unneccessary conversion
    params.push(network)
    call_goose_method("broadcastNetwork", params)
end

def self.broadcast_matrix(payload)
    lines = payload.split("\n")
    columnTitles = lines.shift().split("\t")
    rowTitlesTitle = columnTitles.shift
    rowTitles = []
    data = []
    for line in lines
        items = line.split("\t")
        rowTitles.push(items.shift)
        data.push items
    end

    matrix = {}
    matrix[:name] = @broadcast_name
    matrix[:species] = @species
    matrix[:rowTitlesTitle] = rowTitlesTitle
    matrix[:columnTitles] = columnTitles
    matrix[:rowTitles] = rowTitles
    matrix[:data] = data
    params = []
    params.push @target
    params.push matrix
    call_goose_method("broadcastMatrix", params)
    #pp matrix

end

def self.broadcast_cluster(payload)
    lines = payload.split("\n")
    cluster = {}
    cluster[:name] = @broadcast_name
    cluster[:species] = @species
    genes = lines[0].split("\t")
    conditions = lines[1].split("\t")
    cluster[:rowNames] = genes
    cluster[:columnNames] = conditions
    params = []
    params.push @target
    params.push cluster
    call_goose_method("broadcastCluster", params)
end

def self.broadcast_namelist(payload)
    namelist = {}
    namelist[:name] = @broadcast_name
    namelist[:species] = @species
    namelist[:names] = payload.split("\n")
    params = []
    params.push @target
    params.push namelist
    call_goose_method("broadcastNamelist", params)
end

def self.get_broadcast()
    # this cheats and uses class hinting which we should probably get rid of
    # todo don't rely on class hinting
    result = call_goose_method("getLatestBroadcast", [])   
    unless (@options['--showjson'].nil?)
      puts result.to_json
    end
    if (result['gaggleData']['javaClass'] == "org.systemsbiology.gaggle.core.datatypes.Namelist")
        get_namelist_broadcast(result)
    elsif (result['gaggleData']['javaClass'] == "org.systemsbiology.gaggle.core.datatypes.Cluster")
        get_cluster_broadcast(result)
    elsif (result['gaggleData']['javaClass'] == "org.systemsbiology.gaggle.geese.jsongoose.JsonSerializableDataMatrix")
        get_matrix_broadcast(result)
    elsif (result['gaggleData']['javaClass'].downcase() =~ /network/)
        get_network_broadcast(result)
    end
    #pp result
    #puts result['gaggleData']['javaClass']
end

def self.print_metadata(result)
    if (@options['--suppressmetadata'].nil?)
        puts "#name=#{result['name']}"
        puts "#species=#{result['gaggleData']['species']}"
        puts "#source=#{result['source']}"
    end
end

def self.get_network_broadcast(result)
    puts result.to_json # redundant conversion
end

def self.get_matrix_broadcast(result)
    print_metadata(result)
    header = []
    header << result['gaggleData']['rowTitlesTitle']
    header << result['gaggleData']['columnTitles']
    puts header.join("\t")
    result['gaggleData']['data'].each_with_index do |d, i|
        d.unshift(result['gaggleData']['rowTitles'][i])
        puts d.join("\t")
    end
end

def self.get_cluster_broadcast(result)
    print_metadata(result)
    rownames = result['gaggleData']['rowNames'].join("\t")
    puts rownames
    columnnames = result['gaggleData']['columnNames'].join("\t")
    puts columnnames

end

def self.get_namelist_broadcast(result)
    print_metadata(result)
    namelist = result['gaggleData']['names']
    for name in namelist
        puts name
    end
end

def self.ensure_file_specified()
    if (@options['--file'].nil? or @options['--file'].empty?)
        puts "You must supply a filename (or - for STDIN)"
        exit
    end
end
#code entry point:

    @species = nil
    @broadcast_name = "from script goose"
    @target = "Boss"

    if (ARGV.size == 0)
        usage()
    else
        @options = {}
        opts = parse_options()
        opts.each do |opt, arg|
            value = (arg.inspect.strip.empty?) ? nil : arg.inspect # this doesn't work
            value = arg.inspect.gsub!(%Q("),"")

            @species = value if opt == "--species"
            @broadcast_name = value if opt == "--name"
            @target = value if opt == "--target"

            @options[opt] = value
        end

        #puts "## species = #{@species}, name = #{@broadcast_name}, target = #{@target}"
        #@options.each do |k,v|
        #    puts "###option #{k} has arg #{v}"
        #end

        # handle --execute command
        if (!@options['--execute'].nil?)
            ensure_file_specified()
            #puts "file contents:\n#{get_file_contents(@options['--file'])}"
            contents = get_file_contents()
            puts post_request(contents)
        end

        #handle --getgoosename command
        if (!@options['--getgoosename'].nil?)
            puts call_goose_method('getName', [])
        end

        #handle --getsoosenames command
        if (!@options['--getgoosenames'].nil?)
            names = call_goose_method('getGooseNames', [])
            names.sort!
            names.unshift("Boss")
            puts names
        end

        #handle --hide command
        if (!@options['--hide'].nil?)
            params = []
            params.push @target
            call_boss_method("hide", params)
        end

        #handle --show command
        if (!@options['--show'].nil?)
            params = []
            params.push @target
            call_boss_method("show", params)
        end

        #handle --quit command
        if (!@options['--quit'].nil?)
            begin
                call_goose_method("doExit", [])
            rescue
            end
        end

        #handle --getmethodnames command
        if (!@options['--getmethodnames'].nil?)
            result = call_rmi_method("system", "listMethods", [])
            puts result.sort
        end

        #handle --broadcast command
        if (!@options['--broadcast'].nil?)
            ensure_file_specified()
            do_broadcast()
        end

        #handle --help command
        if (!@options['--help'].nil?)
            usage()
            exit()
        end

        #handle --getbroadcast command
        if (!@options['--getbroadcast'].nil?)
            get_broadcast()
        end


    #make sure we exit here
    end


end