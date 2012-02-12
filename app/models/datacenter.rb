class Datacenter < ActiveRecord::Base
  def self.default
    Datacenter.first || Datacenter.create(:name => "Datacenter")
  end
end
