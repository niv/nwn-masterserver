#!/usr/bin/env ruby

require 'arpie'
require 'rubygems'
require 'eventmachine'
require 'yaml'
require 'pp'

require 'packets'
require 'hexdump'

$config = YAML.load(IO.read("config.yaml")).freeze

$server = nil

require "mode_" + $config['mode']

module ServerHandler
  include NWN::Auth::Packets

  @auth = IAuth.new

  def handle packet, src
    r = case packet

      when "BMST"
        BMSR.new

      when "BMPA"
        obj = BMPR.new
        obj.playername = src.playername
        puts "Validating: #{obj.playername}"
        obj.result = @auth.authenticate(src.playername, src.salt, src.pwhash,
          src.platform) ? 0 : 1

        version = BMRB.new
        version.version = $config['game-version']

        ret = [obj, version]

        motd = @auth.get_motd(src.playername)
        if motd != nil
          ret << BMMB.new
          ret[-1].message = motd
        end

        ret

      when "BMAU"
        obj = BMAR.new
        obj.keys = []

        obj.keys << BMAR::Key.new
        obj.keys[-1].publickey = src.keys[0].publickey
        obj.keys[-1].result, obj.keys[-1].expansion =
          @auth.verify_key(src.keys[0].publickey, src.keys[0].keyhash) ? 0 : 1

        obj.keys << BMAR::Key.new
        obj.keys[-1].publickey = src.keys[1].publickey
        obj.keys[-1].result, obj.keys[-1].expansion =
          @auth.verify_key(src.keys[1].publickey, src.keys[1].keyhash) ? 0 : 1

        obj.keys << BMAR::Key.new
        obj.keys[-1].publickey = src.keys[2].publickey
        obj.keys[-1].result, obj.keys[-1].expansion =
          @auth.verify_key(src.keys[2].publickey, src.keys[2].keyhash) ? 0 :1

        obj

    end
    r = r.is_a?(Array) ? r : [r]
    r.compact
  end

  def receive_data data
    nwserver_port, *nwserver_addr = get_peername[2,6].unpack "nC4"
    nwserver_addr = "%d.%d.%d.%d" % nwserver_addr

    packet = data[0,4]
    begin
      bin = NWN::Auth::Packets.const_get(packet)
    rescue NameError => e
      puts "Ignoring invalid packet #{packet} with data: "
      puts data.hexdump
      return
    end
    src, remaining = bin.from(data[4..-1])

    puts "<- #{nwserver_addr}:#{nwserver_port} " + src.inspect

    to_send = handle(packet, src)
    for obj in to_send
      begin
        obj.lport = $config['nwmaster-server']['port']
      rescue NoMethodError => e
        nil
      end
      write(nwserver_addr, nwserver_port, obj)
    end
  end

  def write host, port, obj
    puts "-> #{host}:#{port} " + obj.inspect
    data = obj.class.name.split("::")[-1] + obj.to
    $server.send_datagram(data, host, port)
  end
end

puts "Listening .."

EM::run {
  $server = EM::open_datagram_socket(
    $config['nwmaster-server']['host'],
    $config['nwmaster-server']['port'],
    ServerHandler
  )
}
