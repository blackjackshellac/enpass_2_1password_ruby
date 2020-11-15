
require_relative 'enpass_item_field'

##
# EnpassItem holds the data for the keys in the enpass item data
# Further the @fields value is an array of EnpassItemField objects
#
class EnpassItem
	# "note": "",
	# "subtitle": "SECURED:ksZUyr83khLXgKuCUYD1fYTxyb31_R7BG7PXyKAVuUilPUdUsw",
	# "template_type": "login.default",
	# "title": "SECURED:rOlmnQvw-98KvB7jfdLCvl0",
	# "updated_at": 1603419844,
	# "uuid": "51614b72-ebba-422a-8b7a-ad634c25ce7a"

	KEYS=%w/auto_submit category favorite fields folders icon note subtitle template_type title updated_at uuid/

	OUTPUT_KEYS=%w/title subtitle note uuid/
	
	attr_reader :item, :auto_submit, :category, :favorite, :fields, :folders, :icon, :note, :subtitle, :template_type, :title, :updated_at, :uuid
	def initialize(item)
		@item = item
		KEYS.each { |key|
			val=@item[key]
			instance_variable_set("@#{key}", val)
			@item.delete(key)
		}

		@fields = [] if @fields.nil?

		# fields is an array of EnpassItemField
		@fields.each_index { |idx|
			field = @fields[idx]
			@fields[idx] = EnpassItemField.new(field)
		}
	end

	def empty?
		@item.empty?
	end

	def search_fields(label)
		@fields.each { |field|
			return field if field.is_label(label)
		}
		nil
	end
end

##
# items is an array of EnpassItem objects stored in @items
#
class EnpassItems
	attr_reader :items, :logger
	def initialize(itemsArray, logger)
		@logger = logger

		@items = []
		itemsArray.each { |item|
			enpassItem = EnpassItem.new(item)
			@items << enpassItem
			@logger.warn "Unknown folder keys: #{enpassItem.item.keys}" unless enpassItem.empty?
		}

	end
end
