require 'sequel'

class IAuth
  @db = Sequel.sqlite("nwmaster.db")
end
