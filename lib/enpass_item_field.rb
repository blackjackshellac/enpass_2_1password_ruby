
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

	def self.enumerate_value(values, value)
		unless value.nil?
			values[value] = { :count=> 0 } if values[value].nil?

			values[value][:count]+=1
		end
		values
	end

	def enumerate_label(labels)
		EnpassItemField.enumerate_value(labels, @label)
	end

	def enumerate_type(types)
		EnpassItemField.enumerate_value(types, @type)
	end

end
