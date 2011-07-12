#!/usr/bin/env ruby

require 'arpie'
require 'rubygems'
require 'eventmachine'

require 'lib/server'
require 'lib/packets'
require 'lib/hexdump'
require 'lib/nwmaster'
require 'lib/iauth'

require 'logger'

Log = Logger.new(STDOUT).freeze

$config = YAML.load(IO.read("config.yaml")).freeze
require "mode/mode_" + $config['mode']
$auth = IAuth.new
Log.info "Using #{$config['mode']} as authentication mode"


$nwmaster_server = nil

Log.info "Listening on #{$config['nwmaster-server'].inspect}"

def server_clean_timer
  EventMachine::Timer.new(5*30) do
    Server.clean
    server_clean_timer
  end
end

EM::run {
  $nwmaster_server = EM::open_datagram_socket(
    $config['nwmaster-server']['host'],
    $config['nwmaster-server']['port'],
    NWMasterHandler
  )
  
  $auth.setup

  server_clean_timer
}
