class IAuthBase

  # Verify the given CD keys.
  # keylist is a list containing [publickey, privatekeyhash] in the
  # order that the client has given them.
  # Expected return value is a hash containing {publickey => expansion}
  # where expansion is either nil for invalid keys, or
  # the base game or expansion pack (0, 1, 2).
  def verify_keys keylist
    {}
  end

  # Authenticates the given account. Not called when
  # only using as a serverside proxy.
  def authenticate account, salt, hash, platform
    false
  end

  # Returns a MOTD to send to clients when authenticating.
  # Currently non-functional.
  def get_motd account
    nil
  end
end