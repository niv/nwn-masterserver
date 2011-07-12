require 'sequel'
require 'digest/md5'

DB = Sequel.sqlite("nwmaster.db")

class IAuth
  class Key < Sequel::Model
  end
  class Account < Sequel::Model
  end

  def verify_key publickey, hash
    key = Key[publickey]
    key or return [false, 0]

    [true, key.expansion]
  end

  def authenticate account, salt, hash, platform
    acc = Account[account]
    acc or return false

    # md5(md5(player password) + Salt)
    hash == Digest::MD5.hexdigest(
        Digest::MD5.hexdigest(acc.password) + salt)
  end

  def get_motd account
    nil
  end

private

end
