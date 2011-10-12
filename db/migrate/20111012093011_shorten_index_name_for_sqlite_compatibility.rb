class ShortenIndexNameForSqliteCompatibility < ActiveRecord::Migration
  def up
    if index_name_exists?("application_instances_servers", old_name, nil)
      rename_index "application_instances_servers", old_name, new_name
    end
  end

  def down
    #nothing or it won't work with sqlite3...
  end

private
  def old_name
    "index_application_instances_servers_on_application_instance_id"
  end

  def new_name
    "index_appinstances_servers_on_appinstance"
  end
end
