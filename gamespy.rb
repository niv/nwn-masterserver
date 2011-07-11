module GamespyHandler
  def receive_data data
    nwserver_port, *nwserver_addr = get_peername[2,6].unpack "nC4"
    nwserver_addr = "%d.%d.%d.%d" % nwserver_addr

    puts "<-G #{nwserver_addr}:#{nwserver_port}\n" + data.hexdump
  end

  def write host, port, obj
    puts "G-> #{host}:#{port} " + obj.inspect
    data = obj.class.name.split("::")[-1] + obj.to
    $gamespy_server.send_datagram(data, host, port)
  end
end
