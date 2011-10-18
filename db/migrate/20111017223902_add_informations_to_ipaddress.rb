class AddInformationsToIpaddress < ActiveRecord::Migration
  def change
    add_column :ipaddresses, :macaddress, :string
    add_column :ipaddresses, :netmask, :string
    add_column :ipaddresses, :interface, :string
  end
end
