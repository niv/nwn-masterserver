module NWN
module Auth
module Packets

# BMAU message is sent when a player attempts to connect to the client application
# and contains data used to independently authenticate the player CD keys.
class BMAU < Arpie::Binary
  field :lport, :uint16, :default => 5121
  field :unknown0, :uint16
  field :ip, :bytes, :length => 4
  field :playerport, :uint16
  field :salt, :bytes, :sizeof => :uint16

  class Key < Arpie::Binary
    field :publickey, :bytes, :sizeof => :uint16
    field :keyhash, :bytes, :sizeof => :uint16
  end

  field :keycount, :uint16
  field :key1pub, :bytes, :sizeof => :uint16
  field :key1hash, :bytes, :sizeof => :uint16
  field :key2pub, :bytes, :sizeof => :uint16
  field :key2hash, :bytes, :sizeof => :uint16
  field :key3pub, :bytes, :sizeof => :uint16
  field :key3hash, :bytes, :sizeof => :uint16
  #field :key1, Key
  #field :key2, Key
  #field :key3, Key

  field :playername, :bytes, :sizeof => :uint16
end


class BMAR < Arpie::Binary
  field :lport, :uint16, :default => 5121

  field :key, :bytes, :length => :all
end

class BMDC < Arpie::Binary
end

class BMHB < Arpie::Binary
end

class BMMO < Arpie::Binary
end

# BMPA message is sent when a player attempts to connect to the client.
# It is used to independently authenticate player's credentials.
class BMPA < Arpie::Binary
  field :lport, :uint16, :default => 5121

  field :salt, :bytes, :sizeof => :uint16

  # gamespy account name
  field :playername, :bytes, :sizeof => :uint16

  # md5(md5(player password) + Salt)
  field :pwhash, :bytes, :sizeof => :uint16

  field :unknown1, :uint16

  # 0x47 lin, 0x4d mac, 0x57 win32
  field :platform, :uint8

  field :unknown2, :uint8
end

# Authentication result.
class BMPR < Arpie::Binary
  field :playername, :bytes, :sizeof => :uint16
  # 0 = valid, 1 = invalid
  field :result, :uint16
end

class BMST < Arpie::Binary
  field :lport, :uint16, :default => 5121
end
class BMSR < Arpie::Binary
  field :lport, :uint16, :default => 5121
end

class BMSU < Arpie::Binary
end

# c2s
class BMBI < Arpie::Binary
  field :lport, :uint16, :default => 5121
  field :account, :bytes, :sizeof => :uint16
end
# c2s
class BMBE < Arpie::Binary
  field :lport, :uint16, :default => 5121
  field :account, :bytes, :sizeof => :uint16
end

# notify about client?
class BMMA < Arpie::Binary
  field :lport, :uint16, :default => 5121
end
class BMRA < Arpie::Binary
  field :lport, :uint16, :default => 5121
  field :unknown0, :uint8
end

# Create account.
class BMCA < Arpie::Binary
  field :lport, :uint16, :default => 5121
  field :account, :bytes, :sizeof => :uint16
end

# server announce message
class BMMB < Arpie::Binary
  field :lport, :uint16, :default => 5121
  field :message, :bytes, :sizeof => :uint16
end

# Contains the game client version.
class BMRB < Arpie::Binary
  field :lport, :uint16, :default => 5121
  field :version, :bytes, :sizeof => :uint16
end

end # module Packets
end # module ServerAuth
end # module NWN
