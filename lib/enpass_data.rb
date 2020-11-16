#
#
require 'json'
require 'csv'
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
	attr_reader :labels, :types, :sortedLabels
	def initialize(opts=DEFAULT_OPTS)
		@json = opts[:json]
		@logger=opts[:logger]
		@labels = {}
		@types = {}
		@sortedLabels = []

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

	def sort_labels_by_count(mincount)
		sorted=@labels.sort_by { |k,v|
			-v[:count]
		}
		@sortedLabels = []
		sorted.each { |entry|
			next if entry[1][:count] < mincount
			@sortedLabels << entry
		}
	end

	def enumerate_item_labels
		@enpassItems.items.each { |item|
			item.fields.each { |itemField|
				itemField.enumerate_label(@labels)
			}
		}
	end

	def print_item_labels
		@sortedLabels.each { |entry|
			@logger.debug "%s: %d [%s (%d)]" % [ entry[0], entry[1][:count], entry[1][:types].join(", "), entry[1][:types].length ]
		}
	end

	def gather_items_csv(csv_file, mincount)
		@csv_labels = Array.new(EnpassItem::OUTPUT_KEYS)
		@sortedLabels.each { |entry|
			label=entry[0]
			@csv_labels << label
		}

		empty=[]
		@csv_labels.each { |label|
			@logger.debug "*"*80
			@logger.debug "Searching for values for '#{label}'"
			cnt=0
			@enpassItems.items.each { |item|
				value = item.label_value(label)
				next if value.empty?
				cnt += 1
				@logger.debug value
			}
			empty << label if cnt < mincount
		}
		@csv_labels -= empty unless empty.empty?

		CSV.open(csv_file,'w', { :write_headers=> true, :headers => @csv_labels}) {|csv|
				@enpassItems.items.each { |item|
					row=[]
					@csv_labels.each { |label|
						row << item.label_value(label)
					}
					csv << row
				}
		}
		#puts @csv_labels.inspect
	end

end
