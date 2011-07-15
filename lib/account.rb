# Online and verified accounts and the server they logged in to recently.
class Account
  @@online = {}

  def self.auth account, host = nil, port = nil
    @@online[account] ||= Account.new(account, host, port)
  end

  # Ping. Still here.
  def self.touch account
    @@online[account].touch if @@online[account]
  end

  # Returns true if the given account is currently
  # authenticated against the given host.
  def self.verify? account, host, port
    @@online[account] != nil &&
      @@online[account].host == host &&
      @@online[account].port == port
  end

  def self.get account
    @@online[account]
  end

  def self.remove account
    @@online.delete(account)
  end

  # Remove old servers
  def self.clean
    @@online.each {|k, v|
      if v.stale?
        @@online.delete(k)
        Log.info "Stale account removed: #{k}"
      end
    }
  end

  attr_reader :account
  attr_reader :host, :port

  private :initialize
  def initialize account, host, port
    touch
    @account = account
    @host, @port = host, port
  end

  def touch
    @last_seen = Time.now
  end

  def stale?
    @last_seen + 5*60+30 < Time.now
  end

end
