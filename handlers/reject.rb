class RejectHandler < BaseHandler
  def verify_keys list
    {}
  end

  def authenticate account, salt, hash, platform
    false
  end
end
