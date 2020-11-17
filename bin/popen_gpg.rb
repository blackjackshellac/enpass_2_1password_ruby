#!/usr/bin/env ruby

require 'json'
require 'open3'

ME=File.basename($0, ".rb")


object={
	:a=>1,
	:b=>{
		:a=>2,
		:c=>0
	}
}

dest="/var/tmp/#{ME}.json.gpg"
gpg="gpg -e -o #{dest}"
begin
	Open3.popen2e(gpg) do |stdin, stdout_stderr, wait_thread|
	  Thread.new do
	    stdout_stderr.each {|l| puts l }
	  end

	  stdin.puts JSON.pretty_generate(object)
	  stdin.close

	  wait_thread.value

	  puts "object written to #{dest}"
end

rescue Errno::ENOENT => e
	$stderr.puts "ERROR: gpg not found: #{gpg}"
	exit 1
rescue => e
	$stderr.puts "#{e.class}: #{e.message}"
	puts e.backtrace.join("\n")
	exit 1
end
