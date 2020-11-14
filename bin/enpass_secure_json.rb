#!/usr/bin/env ruby
#
# Obfuscate values in enpass json files for testing
#
# gpg -d enpass.json.gpg | ./enpass_secure_json.rb > enpass_obfus.json
#

require 'json'
require_relative '../lib/logger'
require 'securerandom'

ME=File.basename($0, ".rb")
MERB=File.basename($0)

$log=Logger.create(STDERR)

CATEGORIES=%w/login identity note computer password/

##
# Obfuscate the value represented by the given hash object key
#
# @param [Hash] hash
# @param [String] key
# @param [Boolean] preserve_length
#
# @return [Boolean] true if hash value has been changed for key
#
def secure(hash, key, preserve_length=true)
	val=hash[key]
	return false if val.nil? || val.empty?
	secval=SecureRandom.urlsafe_base64(preserve_length ? val.length : 32)
	hash[key]="SECURED:#{secval}"
	true
end

##
# Update timestamp in given keys
#
# @param [Hash] hash hash whose timestamp is to be updates
# @param [Array] keys keys to be updated with current timestamp
#
def update(hash, keys)
	now=Time.now.to_i
	keys.each { |key|
		next unless hash.key?(key)
		hash[key]=now
	}
end

$log.info "Sample usage: cat foo.json.gpg | ./#{MERB}"
$log.info "Waiting for input on standard input"

# read from stdin
json=$stdin.read
obj=JSON.parse(json)

# obfuscate folders section
folders=obj["folders"]
folders.each { |folder|
	next unless secure(folder, "title")
	update(folder, %w/updated_at value_updated_at/)
}

# obfuscate items section
items=obj["items"]
$log.info items.class
items.each { |item|
	cat=item["category"]
	$log.warn "category not found" if cat.nil?
	fields=item["fields"]
	if fields.nil?
	  $log.warn "fields not found for category #{cat}" if fields.nil?
	else
		fields.each { |field|
			type=field["type"]
			value=field["value"]
			next if value.empty?
			next unless secure(field, "value", !type.eql?("password"))
			#"updated_at": 1576761092,
			#"value": "",
			#"value_updated_at": 1576761092
			update(field, %w/updated_at value_updated_at/)
		}
	end
	secure(item, "note")
	secure(item, "subtitle")
	secure(item, "title")
}

puts JSON.pretty_generate(obj)
