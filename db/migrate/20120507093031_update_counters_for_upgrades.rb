class UpdateCountersForUpgrades < Mongoid::Migration
  def self.up
    Upgrade.all.map(&:save)
  end

  def self.down
  end
end
