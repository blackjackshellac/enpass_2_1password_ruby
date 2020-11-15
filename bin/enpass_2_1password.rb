#!/usr/bin/env ruby
#
# Convert enpass json file to something 1password can easily import
#

require 'json'
require 'optparse'
require_relative '../lib/logger'
require_relative '../lib/enpass_data'

class Enpass_2_1password
	MERB=File.basename($0)
	## Process name without .rb extension
	ME=File.basename($0, ".rb")
	# Directory where the script lives, resolves symlinks
	MD=File.expand_path(File.dirname(File.realpath($0)))

	attr_reader :logger, :json_file, :json
	def initialize
			@logger = Logger.create()
			@json_file = STDIN
	end

	def parse_clargs
		optparser=OptionParser.new { |opts|
			opts.banner = "#{MERB} [options]\n"

			opts.on('-j', '--json FILE', String, "JSON file path or - to read from STDIN") { |json|
				@json_file = '-'.eql?(json) ? STDIN : File.open(json, "r")
			}

			opts.on('-D', '--debug', "Enable debugging output") {
				@logger.level = Logger::DEBUG
			}

			opts.on('-h', '--help', "Help") {
				$stdout.puts ""
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
		@logger.info "Running converter"
		@json=@json_file.read
		@enpass_data = EnpassData.new(:json=>@json, :logger=>@logger)

		@enpass_data.enumerate_item_labels
		@enpass_data.print_item_labels

	rescue => e
		@logger.error "#{e.class}: #{e.message}"
		puts e.backtrace.join("\n")
		exit 1
	end
end

ep21pw = Enpass_2_1password.new
ep21pw.parse_clargs
ep21pw.run
