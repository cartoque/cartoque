class FixIpaddressAddressIntegerLimit < ActiveRecord::Migration
  def self.up
    change_column :ipaddresses, :address, :integer, limit: 8
  end

  def self.down
    #it's a fix, we don't want to rollback this!
  end
end
