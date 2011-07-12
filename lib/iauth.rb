class IAuthBase

  # Verify the given CD key.
  def verify_key publickey, hash
    return [false, 0]
  end

  # Authenticates the given account. Not called when
  # only using as a serverside proxy.
  def authenticate account, salt, hash, platform
    return false
  end

  # Returns a MOTD to send to clients when authenticating.
  # Currently non-functional.
  def get_motd account
    return nil
  end

  def setup
  end
end