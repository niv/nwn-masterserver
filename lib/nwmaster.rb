module NWMasterHandler
  include NWN::Auth::Packets

  def handle packet, src, host, port
    r = case packet

      when "BMST"
        Server.touch(host, port)
        BMSR.new

      when "BMPA"
        obj = BMPR.new
        obj.playername = src.playername
        Log.info "Validating account: #{obj.playername}"
        obj.result = $auth.authenticate(src.playername, src.salt, src.pwhash,
          src.platform) ? 0 : 1

        version = BMRB.new
        version.version = $config['game-version']

        ret = [obj, version]

        motd = $auth.get_motd(src.playername)
        if obj.result == 0 && motd != nil
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

      when "BMSU"
        Server.touch(host, port)
        nil

      when "BMHB"
        server = Server.touch(host, port)
        nil

      when "BMMO"
        Server.touch(host, port, src.modulename, src.expansion)
        nil

      when "BMDC"
        Server.remove(host, port) if src.players.size == 0
        nil

    end
    r = r.is_a?(Array) ? r : [r]
    r.compact
  end

  def receive_data data
    nwserver_port, *nwserver_addr = get_peername[2,6].unpack "nC4"
    nwserver_addr = "%d.%d.%d.%d" % nwserver_addr
    src_fmt = "%s:%d" % [nwserver_addr, nwserver_port]

    packet = data[0,4]
    begin
      bin = NWN::Auth::Packets.const_get(packet)
      src, remaining = bin.from(data[4..-1])
    rescue NameError, Arpie::EIncomplete => e
      Log.warn "#{src_fmt}: Dropping invalid packet: "
      Log.warn data.hexdump
      return
    end

    Log.debug { "<-M #{src_fmt}: " + src.inspect }

    to_send = handle(packet, src, nwserver_addr, nwserver_port)
    for obj in to_send
      write(nwserver_addr, nwserver_port, obj)
    end
  end

  def write host, port, obj
    Log.debug { "M-> #{host}:#{port}: " + obj.inspect }
    data = obj.class.name.split("::")[-1] + obj.to
    $nwmaster_server.send_datagram(data, host, port)
  end
end

