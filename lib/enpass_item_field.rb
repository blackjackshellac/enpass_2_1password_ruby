
##
# EnpassItemField holds the data for the values in each enpass item field
#
class EnpassItemField
	# {
	#   "label": "Username",
	#   "order": 1,
	#   "sensitive": 0,
	#   "type": "username",
	#   "uid": 10,
	#   "updated_at": 1605370638,
	#   "value": "SECURED:Q1ZrlXRk2npNIQ",
	#   "value_updated_at": 1605370638
	# },
	KEYS=%w/label order sensitive type uid updated_at value value_updated_at/

	# @attr_reader field
	attr_reader :field
	# these are the item fields
	attr_reader :label, :type, :value
	attr_reader :order, :sensitive, :uid, :updated_at, :value_updated_at
	def initialize(field)
		@field=field
		KEYS.each { |key|
			val=@field[key]
			instance_variable_set("@#{key}", val)
			@field.delete(key) unless val.nil?
		}
	end

	def empty?
		@item.empty?
	end

	def enumerate_label(labels)
		data=labels[@label]
		if data.nil?
			data = {
				:count => 0,
				:types => []
			}
		end

		data[:count] += 1
		data[:types] << @type unless data[:types].include?(@type)

		labels[@label] = data

		labels
	rescue => e
		puts "#{e}: #{labels[@label]} #{@label} #{@type}"
		puts e.backtrace.join("\n")
		exit 1
	end

	def is_label(label)
		@label.eql?(label)
	end
end
