#!/usr/bin/env ruby

require 'json'
require 'time'

current_file_path = File.expand_path(__FILE__)
CURRENT_DIR = File.dirname(current_file_path)

def run_speedtest(server)
  puts "Running Speedtest - #{server}"
  json_result = `speedtest -s #{server} -f json`
  result = JSON.parse(json_result)

  # Time,Server,Ping,Download,Upload
  values = [
    Time.now.utc.iso8601,
    "#{result.dig('server', 'location')} (#{result.dig('server', 'name')})",
    result.dig('ping', 'latency'),
    (result.dig('download', 'bandwidth') * 8 / 10^7).round(2),
    (result.dig('upload', 'bandwidth') * 8 / 10^7).round(2),
  ]
  line = "#{values.join('|')}\n"
  puts "Result: #{line}"

  File.open(File.join(CURRENT_DIR, 'data', 'speedtest-output.csv'), 'a').write(line)
end


servers = File.open(File.join(CURRENT_DIR, 'data', 'server-list.txt')).read.split("\n")

servers.each { |server| run_speedtest(server) }