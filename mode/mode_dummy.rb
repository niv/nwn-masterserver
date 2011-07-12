class IAuth < IAuthBase
  def verify_keys list
    ret = {}
    list.each_with_index {|h, idx|
      ret[h[0]] = idx
    }
    ret
  end

  def authenticate account, salt, hash, platform
    true
  end
end
