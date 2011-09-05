require 'settler'

class Settler
  def self.safe_cas_server
    value = Settler.cas_server.try(:value).try(:strip)
    value.presence || self.config["cas_server"]["value"]
  end
end
