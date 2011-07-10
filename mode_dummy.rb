class IAuth
  def verify_key publickey, hash
    expansion = 0
    [true, expansion]
  end

  def authenticate account, salt, hash, platform
    true
  end

  def get_motd account
    nil
  end
end
