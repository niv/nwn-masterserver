#!/usr/bin/env ruby

require 'arpie'
require 'rubygems'
require 'eventmachine'
require 'packets'
require 'hexdump'
require 'nwmaster'
require 'gamespy'

$config = YAML.load(IO.read("config.yaml")).freeze
require "mode_" + $config['mode']
$auth = IAuth.new

$nwmaster_server = nil
$gamespy_server  = nil

puts "Listening .."

EM::run {
  $nwmaster_server = EM::open_datagram_socket(
    $config['nwmaster-server']['host'],
    $config['nwmaster-server']['port'],
    NWMasterHandler
  )
  $gamespy_server = EM::open_datagram_socket(
    $config['gamespy-server']['host'],
    $config['gamespy-server']['port'],
    GamespyHandler
  )
}
