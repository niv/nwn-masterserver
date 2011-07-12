class IAuth
  @exp = 0

  def verify_key publickey, hash
    @exp = 0 unless @exp
    expansion = @exp
    @exp += 1
    @exp = 0 if @exp == 3
    [true, expansion]
  end

  def authenticate account, salt, hash, platform
    true
  end

  def get_motd account
    nil
  end
end
