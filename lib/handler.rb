class BaseHandler
  # Verify the given CD keys.
  # keylist is a list containing [publickey, privatekeyhash] in the
  # order that the client has given them.
  # Expected return value is a hash containing {publickey => expansion}
  # where expansion is either nil for invalid keys, or
  # the base game or expansion pack (0, 1, 2).
  def verify_keys keylist
  end

  # Authenticates the given account. Not called when
  # only using as a serverside proxy.
  def authenticate account, salt, hash, platform
  end

  # Returns a MOTD to send to clients when authenticating.
  def get_motd account
  end
end

module HandlerChain
  @@handlers = []

  def self.push name
    require "handlers/#{name}.rb"
    name = name.capitalize + "Handler"
    klass = Object.const_get(name)
    @@handlers << klass.new
  end

  def self.method_missing method, *va
    for handler in @@handlers do
      next unless handler.respond_to?(method)
      ret = handler.method(method).call(*va)
      return ret if ret != nil
    end
    nil
  end
end


