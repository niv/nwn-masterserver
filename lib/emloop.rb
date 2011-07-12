#!/usr/bin/env ruby

require 'arpie'
require 'rubygems'
require 'eventmachine'

require 'lib/packets'
require 'lib/hexdump'
require 'lib/nwmaster'

$config = YAML.load(IO.read("config.yaml")).freeze
require "mode/mode_" + $config['mode']
$auth = IAuth.new

$nwmaster_server = nil

puts "Listening .."

EM::run {
  $nwmaster_server = EM::open_datagram_socket(
    $config['nwmaster-server']['host'],
    $config['nwmaster-server']['port'],
    NWMasterHandler
  )
}
