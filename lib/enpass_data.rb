#
#
require 'json'
require_relative '../lib/logger'
require_relative '../lib/enpass_folders'
require_relative '../lib/enpass_items'

##
# EnpassData holds the json data and parses to an @enpass object
# and then further parses that down to the two subsections "folders"
# and "items"
#
class EnpassData
	DEFAULT_OPTS = {
		:json=>nil,
		:logger=>Logger.create()
	}

	attr_reader :json, :enpass, :enpassFolders, :enpassItems
	attr_reader :labels, :types
	def initialize(opts=DEFAULT_OPTS)
		@json = opts[:json]
		@logger=opts[:logger]
		@labels = {}
		@types = {}

		parse_json

		parse_folders
		parse_items
	end

	def parse_json
		@enpass=JSON.parse(@json)
	rescue => e
		puts e.backtrace.join("\n")
		@logger.die "Failed to parse json: #{e}"
	end

	def parse_folders
		@folders=@enpass["folders"]
		@logger.info "folders is a #{@folders.class}"
		@enpassFolders = EnpassFolders.new(@folders, @logger)
	end

	def parse_items
		@items=@enpass["items"]
		@logger.info "items is a #{@items.class}"
		@enpassItems = EnpassItems.new(@items, @logger)
	end

	def search_fields
		@enpassItems.items.each { |item|
			item.fields.each { |itemField|
				itemField.enumerate_label(@labels)
				itemField.enumerate_type(@types)
			}
		}
	end

end
