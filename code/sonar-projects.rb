#!/usr/bin/env ruby 

# == Synopsis 
#   Execute sonar on all the projects contained into a directory. It can also update from 
# subversion repositories and checkout projects defined in a CSV file.
#
# Note for JRuby users : the command is jruby sonar-projects.rb [OPTIONS]
#
# == Examples
#   Checkout the projects defined into the file 'open-source-projects.csv' then execute sonar
#   on the maven projects contained into the directory/Users/you/projects (even if they are not
#   defined into the CSV file.)
#     sonar-projects -d /Users/you/projects -f open-source-projects.csv
#
#   Execute sonar on all the projects contained in the directory .
#     sonar-projects
#
#   Update from subversion then execute sonar on all the maven projects contained
#   into the directory /Users/you/projects.
#     sonar-projects -u -d /Users/you/projects
#
#   Execute sonar with the maven profile profile1 
#     sonar-projects -m Pprofile1
#
# == Usage 
#   sonar-projects [options]
#
#   For help use: sonar-projects -h
#
# == Options
#   -h, --help          Displays help message
#   -v, --version       Display the version, then exit
#   -V, --verbose       Verbose output
#   -d, --dir           Root directory of projects
#   -f, --file          Import additional projects from CSV file
#   -u, --update        Update from subversion
#   -m, --maven         Maven parameters(do not prefix by -. Example : Pmyprofile) 
#
# == Import projects defined into a CSV file
#   Each row defines a project with its name and its subversion URL. Example :
#
#     sonar,https://svn.codehaus.org/sonar/trunk
#     logback,http://svn.qos.ch/repos/logback/trunk
#
# == Author
#   Simon Brandhof
#
# == Copyright
#   Copyright (C) 2007-2008 Hortis-GRC SA. Licensed under the Lesser GPL license.

require 'find'
require 'CSV'
require 'optparse' 
require 'rdoc/usage'
require 'ostruct'

class Sonar
  MVN_GOALS='org.codehaus.sonar:sonar-maven-plugin::sonar'
  
  attr_reader :root
  
  def initialize(root)
    @root = root
  end
  
  def deactivated_project?(project_name)
    exist_project?("#{project_name}_")
  end
  
  def exist_project?(project_name)
    File.exists?("#{root}/#{project_name}") and File.exists?("#{root}/#{project_name}/pom.xml")
  end
  
  def checkout_from_csv(csv_filename)
    CSV::Reader.parse(File.open(csv_filename, 'rb')) do |row|
        project_name=row[0]
        svn_url=row[1]
        project_dir="#{@root}/#{project_name}"
        
        if not ( exist_project?(project_name) or deactivated_project?(project_name))
          p "checkout #{project_name}..."
          system "svn co --non-interactive --quiet #{svn_url} #{project_dir}"
        end
    end
  end
  
  def sonar(project_names, maven_arguments='', update_subversion=true)
    project_names.each do |project_name|
      if exist_project?(project_name) and not deactivated_project?(project_name)
    	  project_dir = "#{@root}/#{project_name}"
    	  log_filename="#{project_dir}/sonar.log"
    	
    	  if update_subversion
    	    puts "update #{project_name}..."
    	    system "svn update --non-interactive --quiet #{project_dir}"
  	    end
  	    puts "sonar #{project_name}..."
  	    sonar_on_sonar = ((project_name=='sonar') ? '-DskipInstall=true' : '')
  	    mvn_parameters = ((maven_arguments=='') ? '' : "-#{maven_arguments}")
  	    mvn_command = "mvn #{mvn_parameters} --batch-mode #{sonar_on_sonar} -f #{project_dir}/pom.xml #{MVN_GOALS} > #{log_filename}"
  	    puts mvn_command
    	  system mvn_command
      end
    end    
  end
  
  def maven_projects
    names = []
    Find.find(@root) do |path|
      if File.directory?(path)
      	next if path==@root
        if not path[-1..-1]=='_' and File.exist? "#{path}/pom.xml"
        	names.insert(0, File.basename(path))
        end
        Find.prune
      end
    end
    names
  end
end

class App
  VERSION = '0.0.1'

  attr_reader :options

  def initialize(arguments, stdin)
    @arguments = arguments
    @stdin = stdin

    # Set defaults
    @options = OpenStruct.new
    @options.verbose = false
    @options.dir = '.'
    @options.csv = nil
    @options.update_subversion = false
    @options.maven_parameters = ''
  end

  # Parse options, check arguments, then process the command
  def run
    if parsed_options? && arguments_valid? 
      puts "Start at #{DateTime.now}\n\n" if @options.verbose

      process_arguments            
      process_command

      puts "\nFinished at #{DateTime.now}" if @options.verbose

    else
      output_usage
    end
  end

  protected

    def parsed_options?
      # Specify options
      opts = OptionParser.new 
      opts.on('-v', '--version')    { output_version ; exit 0 }
      opts.on('-h', '--help')       { output_help }
      opts.on('-V', '--verbose')    { @options.verbose = true }  
      opts.on('-d [DIR]', '--dir')        { |argument|  @options.dir = argument}
      opts.on('-f [FILE]', '--file', 'Import additional projects from CSV file')        { |argument| @options.csv = argument}
      opts.on('-u', '--update')     { @options.update_subversion = true}
      opts.on('-m [PARAMS]', '--maven') { |argument| @options.maven_parameters = argument}
      opts.parse!(@arguments) rescue return false

      process_options
      true      
    end

    # Performs post-parse processing on options
    def process_options
      
    end

    def output_options
      puts "Options:\n"

      @options.marshal_dump.each do |name, val|        
        puts "  #{name} = #{val}"
      end
    end

    # True if required arguments were provided
    def arguments_valid?
      true 
    end

    # Setup the arguments
    def process_arguments
      # TO DO - place in local vars, etc
    end

    def output_help
      output_version
      RDoc::usage() #exits app
    end

    def output_usage
      RDoc::usage('usage') # gets usage from comments above
    end

    def output_version
      puts "#{File.basename(__FILE__)} version #{VERSION}"
    end

    def process_command
      sonar=Sonar.new(@options.dir)
      if @options.csv
        sonar.checkout_from_csv(@options.csv)
      end
      sonar.sonar(sonar.maven_projects, @options.maven_parameters, @options.update_subversion)
    end

    def process_standard_input
      input = @stdin.read      
    end
end


# Create and run the application
app = App.new(ARGV, STDIN)
app.run