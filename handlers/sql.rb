require 'sequel'
require 'digest/md5'

DB = Sequel.sqlite("nwmaster.db")

class SqlHandler < BaseHandler
  class Key < Sequel::Model
  end
  class Account < Sequel::Model
  end

  def verify_keys list
    ret = {}
    key.each {|pub, priv|
      ret[pub] =  Key[pub] ? Key[pub].expansion : nil
    }
    ret
  end

  def authenticate account, salt, hash, platform
    acc = Account[account]
    acc or return false

    # md5(md5(player password) + Salt)
    hash == Digest::MD5.hexdigest(
        Digest::MD5.hexdigest(acc.password) + salt)
  end
end
