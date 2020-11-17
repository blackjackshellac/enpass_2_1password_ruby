#!/usr/bin/env ruby
#
# Convert enpass json file to something 1password can easily import
#

require 'json'
require 'optparse'
require_relative '../lib/logger'
require_relative '../lib/enpass_data'

class Enpass_2_1password
	VERSION="0.9"
	## Process name with extension
	MERB=File.basename($0)
	## Process name without .rb extension
	ME=File.basename($0, ".rb")
	# Directory where the script lives, resolves symlinks
	MD=File.expand_path(File.dirname(File.realpath($0)))

	attr_reader :logger, :json_file, :json, :csv
	def initialize
			@logger = Logger.create()
			@json_file = STDIN
			@mincount = 5
			@csv = 'enpass_2_1password.csv'
	end

	def parse_clargs
		optparser=OptionParser.new { |opts|
			opts.banner = "$ #{MERB} [options]\n"

			opts.on('-j', '--json FILE', String, "JSON file path or - to read from STDIN") { |json|
				@json_file = '-'.eql?(json) ? STDIN : File.open(json, "r")
			}

			opts.on('-c', '--csv FILE', String, "Output file for csv data, def is #{@csv}") { |csv|
				@csv = csv
			}

			opts.on('-x', '--exclude NUM', Integer, "Exclude labels with a row count lower than this, def is #{@mincount}") { |num|
				@mincount = num
			}

			opts.on('-D', '--debug', "Enable debugging output") {
				@logger.level = Logger::DEBUG
			}

			opts.on('-h', '--help', "Help") {
				$stdout.puts "#{ME} ver #{VERSION}\n\n"
				$stdout.puts opts
				exit 0
			}

		}
		optparser.parse!
	rescue OptionParser::MissingArgument => e
		@logger.die e.message
	rescue => e
		@logger.error e.to_s
		puts e.backtrace.join("\n")
		exit 1
	end

	def run

		exit_code=0

		@logger.info "Running converter"
		@json=@json_file.read
		@enpass_data = EnpassData.new(:json=>@json, :logger=>@logger)

		@enpass_data.enumerate_item_labels
		@enpass_data.sort_labels_by_count(@mincount)
		@enpass_data.print_item_labels

		@enpass_data.gather_items_csv(@mincount)
		@enpass_data.write_csv(@csv)

	rescue ArgumentError => e
		@logger.error "#{e.class}: #{e.message}"
		exit_code=1
	rescue => e
		@logger.error "#{e.class}: #{e.message}"
		puts e.backtrace.join("\n")
		exit_code=2
	ensure
		exit exit_code
	end
end

ep21pw = Enpass_2_1password.new
ep21pw.parse_clargs
ep21pw.run
