#!/usr/bin/env ruby 

# == Synopsis 
#   Use this command-line utility to create and update CrowdFlower jobs.
#
# == Examples
#   Create a new job and populate it with data from a twitter feed.
#     crowdflower -n -u 'http://search.twitter.com/search?q=milksteak'
#
#   Other examples:
#     crowdflower -q bar.doc
#     crowdflower --verbose foo.html
#
# == Usage 
#   crowdflower [options] source_file
#
#   For help use: crowdflower -h
#
# == Options
#   -h, --help          Displays help message
#   -v, --version       Display the version, then exit
#   -q, --quiet         Output as little as possible, overrides verbose
#   -V, --verbose       Verbose output
#   -n, --new           Create a new job
#   -u, --uri           Accepts an RSS, Atom, XML, or JSON data feed
#   -f, --file          Accepts .csv, .tsv, .xls, .xlsx, and .ods
#   TO DO - add additional options
#
# == Author
#   Mark Erdmann
#
# == Copyright
#   Copyright (c) 2007 CrowdFlower. Licensed under the MIT License:
#   http://www.opensource.org/licenses/mit-license.php


# TO DO - update Synopsis, Examples, etc
# TO DO - change license if necessary



require 'optparse' 
require 'rdoc/usage'
require 'ostruct'
require 'date'


class App
  VERSION = '0.0.1'
  
  attr_reader :options

  def initialize(arguments, stdin)
    @arguments = arguments
    @stdin = stdin
    
    # Set defaults
    @options = OpenStruct.new
    @options.verbose = false
    @options.quiet = false
    # TO DO - add additional defaults
  end

  # Parse options, check arguments, then process the command
  def run
        
    if parsed_options? && arguments_valid? 
      
      puts "Start at #{DateTime.now}\n\n" if @options.verbose
      
      output_options if @options.verbose # [Optional]
            
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
      opts.on('-q', '--quiet')      { @options.quiet = true }
      opts.on('-n', '--new')        { @options.newjob = true }
      opts.on('-u', '--uri')        { @options.uri = }
      # TO DO - add additional options
            
      opts.parse!(@arguments) rescue return false
      
      process_options
      true      
    end

    # Performs post-parse processing on options
    def process_options
      @options.verbose = false if @options.quiet
    end
    
    def output_options
      puts "Options:\n"
      
      @options.marshal_dump.each do |name, val|        
        puts "  #{name} = #{val}"
      end
    end

    # True if required arguments were provided
    def arguments_valid?
      # TO DO - implement your real logic here
      true if @arguments.length == 1 
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
      # TO DO - do whatever this app does
      
      #process_standard_input # [Optional]
    end

    def process_standard_input
      input = @stdin.read      
      # TO DO - process input
      
      # [Optional]
      # @stdin.each do |line| 
      #  # TO DO - process each line
      #end
    end
end


# TO DO - Add your Modules, Classes, etc


# Create and run the application
app = App.new(ARGV, STDIN)
app.run
