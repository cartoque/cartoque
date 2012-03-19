class CleanupServersTable < ActiveRecord::Migration
  def up
    remove_column "servers", "previous_name"
    remove_column "servers", "subnet"
    remove_column "servers", "lastbyte"
  end

  def down
    add_column "servers", "previous_name", "string"
    add_column "servers", "subnet", "string", :limit => 23
    add_column "servers", "lastbyte", "string", :limit => 9
  end
end
