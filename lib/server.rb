# Server registered with this masterserver
class Server
  @@online = {}
  
  def self.all
    @@online
  end
  
  def self.touch host, port, modulename = nil, expansion = nil
    unless @@online[host + port.to_s]
      Log.info "Server appeared: #{host}:#{port}"
      @@online[host + port.to_s] ||= Server.new(host, port)
    end
    srv = @@online[host + port.to_s]
    
    srv.modulename = modulename if modulename
    srv.expansion = expansion if expansion
    srv.touch
    srv
  end
  
  # Remove server
  def self.remove host, port
    Log.info "Server disappeared: #{host}:#{port}"
    @@online.delete(host + port.to_s)
  end
  
  def self.get
    @@online[host + port.to_s]
  end
  
  # Remove old servers
  def self.clean
    @@online.each {|k, v|
      if v.stale?
        @@online.delete(k)
        Log.info "Stale server removed: #{k}"
      end
    }
  end
  
  attr_reader :last_seen
  attr_reader :host, :port
  attr_writer :modulename
  attr_writer :expansion
  
  private :initialize
  def initialize host, port
    touch
    @host = host
    @port = port
    @modulename = nil
    @expansion = nil
  end
  
  def touch
    @last_seen = Time.now
  end
  
  def stale?
    @last_seen + $config['server-timeout'] < Time.now
  end
end
