#!/usr/bin/env ruby

require 'pry'
require 'net/http'
require 'json'
require 'time'

current_file_path = File.expand_path(__FILE__)
CURRENT_DIR = File.dirname(current_file_path)
OUTPUT_FILE = File.join(CURRENT_DIR, 'data', 'speedtest-output.csv')
SERVER_LIST_FILE = File.join(CURRENT_DIR, 'data', 'server-list.txt')

def create_output_file
  return if File.exists?(OUTPUT_FILE)

  headers = "Time\tServer\tPing\tDownload\tUpload\tMy IP Address\n"
  File.open(OUTPUT_FILE, 'w') { |f| f.write(headers) }
end

def get_ip_address
  url = URI('https://api.ipify.org')
  Net::HTTP.get(url)
end

def run_speedtest(server, ip_address: '')
  return if server[0] == '#'

  puts "Running Speedtest - #{server}"
  json_result = `speedtest -s #{server} -f json`
  result = JSON.parse(json_result)

  # Time,Server,Ping,Download,Upload,IP Address
  values = [
    Time.now.utc.iso8601,
    "#{result.dig('server', 'location')} (#{result.dig('server', 'name')})",
    result.dig('ping', 'latency'),
    (result.dig('download', 'bandwidth').to_f * 8 / 1_000_000).round(2),
    (result.dig('upload', 'bandwidth').to_f * 8 / 1_000_000).round(2),
    ip_address
  ]
  line = "#{values.join("\t")}\n"
  puts "Result: #{line}"

  File.open(OUTPUT_FILE, 'a') { |f| f.write(line) }
end

create_output_file

ip_address = get_ip_address
servers = File.open(SERVER_LIST_FILE).read.split("\n")

servers.each { |server| run_speedtest(server, ip_address:) }