module NWN
module Auth
module Packets

# BMAU message is sent when a player attempts to connect to the client application
# and contains data used to independently authenticate the player CD keys.
class BMAU < Arpie::Binary
  field :lport, :uint16, :default => 5121
  # Presumably, this field holds count of authentication requests in the message
  # or the message version. Either way, this value should always be 1.
  field :unknown0, :uint16, :default => 1
  # The player local IP (may be LAN-local too)
  field :ip, :bytes, :length => 4
  # The player port
  field :playerport, :uint16

  field :salt, :bytes, :sizeof => :uint16

  class Key < Arpie::Binary
    # A public key is constructed of the first eight even characters of
    # a private key.
    field :publickey, :bytes, :sizeof => :uint16
    # md5(privatekey + salt)
    field :keyhash, :bytes, :sizeof => :uint16
  end

  field :keys, :list, :of => Key,
    :sizeof => :uint16

  field :playername, :bytes, :sizeof => :uint16
end


class BMAR < Arpie::Binary
  class Key < Arpie::Binary
    field :publickey, :bytes, :sizeof => :uint16
    field :result, :uint16
    field :expansion, :uint16
  end

  field :keys, :list, :of => Key,
    :sizeof => :uint16
end

# A list of player public keys went away
class BMDC < Arpie::Binary
  field :lport, :uint16, :default => 5121

  class Player < Arpie::Binary
    field :keys, :list,
      :of => :bytes, :of_opts => { :sizeof => :uint16 },
      :sizeof => :uint16
  end

  field :players, :list,
    :of => Player, :sizeof => :uint16

#  field :keys, :list,
#    :of => :bytes, :of_opts => { :sizeof => :uint16 }, 
#    :sizeof => :uint16,
#    :optional => true
end

# Server heartbeat. "Still here." Empty packet.
class BMHB < Arpie::Binary
end

# Notification about module load/startup.
class BMMO < Arpie::Binary
  # 0: none, 1: sou, 2: hotu, 3: both
  field :expansion, :uint8
  field :modulename, :bytes, :sizeof => :uint16
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

  field :unknown1, :uint16, :default => 0

  # 0x4c(ascii L) lin, 0x4d(ascii M) mac, 0x57(ascii W) win32
  field :platform, :uint8

  field :unknown2, :uint8, :default => 0
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
  # Should always be 0x0000
  field :unknown0, :uint16, :default => 0x0000
end

class BMSU < Arpie::Binary
  field :platform, :uint8
  field :gametype, :uint8
  field :build, :uint16
  field :unknown0, :uint16, :default => 0
  field :gamespy, :uint8
  field :unknown1, :uint8, :default => 0
  # 0: none, 1: sou, 2: hotu, 3: both
  field :expansion, :uint8
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
