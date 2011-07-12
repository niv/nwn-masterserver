module NWMasterHandler
  include NWN::Auth::Packets

  def handle packet, src
    r = case packet

      when "BMST"
        BMSR.new

      when "BMPA"
        obj = BMPR.new
        obj.playername = src.playername
        puts "Validating account: #{obj.playername}"
        obj.result = $auth.authenticate(src.playername, src.salt, src.pwhash,
          src.platform) ? 0 : 1

        version = BMRB.new
        version.version = $config['game-version']

        ret = [obj, version]

        motd = $auth.get_motd(src.playername)
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
        a, b = $auth.verify_key(src.keys[0].publickey, src.keys[0].keyhash)
        obj.keys[-1].result, obj.keys[-1].expansion = a ? 0 : 1, b

        obj.keys << BMAR::Key.new
        obj.keys[-1].publickey = src.keys[1].publickey
        a, b = $auth.verify_key(src.keys[1].publickey, src.keys[1].keyhash)
        obj.keys[-1].result, obj.keys[-1].expansion = a ? 0 : 1, b

        obj.keys << BMAR::Key.new
        obj.keys[-1].publickey = src.keys[2].publickey
        a, b = $auth.verify_key(src.keys[2].publickey, src.keys[2].keyhash)
        obj.keys[-1].result, obj.keys[-1].expansion = a ? 0 : 1, b

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
      if $DEBUG
        puts "Ignoring invalid packet #{packet} with data: "
        puts data.hexdump
      end
      return
    end
    begin
      src, remaining = bin.from(data[4..-1])
    rescue Arpie::EIncomplete => incomplete
      return
    end

    puts "<-M #{nwserver_addr}:#{nwserver_port} " + src.inspect if $DEBUG

    to_send = handle(packet, src)
    for obj in to_send
      write(nwserver_addr, nwserver_port, obj)
    end
  end

  def write host, port, obj
    puts "M-> #{host}:#{port} " + obj.inspect if $DEBUG
    data = obj.class.name.split("::")[-1] + obj.to
    $nwmaster_server.send_datagram(data, host, port)
  end
end

