class RebuildSomeBrokenRelations < ActiveRecord::Migration
  def up
    BackupException.all.each do |item|
      if item.attributes.has_key?("user_mongo_id")
        item.user_id = item.user_mongo_id
        item.unset("user_mongo_id")
        item.save
      end
      if item.attributes.has_key?("mongo_server_ids")
        item.server_ids = item.mongo_server_ids
        item.unset("mongo_server_ids")
        item.save
      end
    end
    License.all.each do |item|
      if item.attributes.has_key?("mongo_server_ids")
        item.server_ids = item.mongo_server_ids
        item.unset("mongo_server_ids")
        item.save
      end
    end
    ApplicationInstance.all.each do |item|
      if item.attributes.has_key?("mongo_server_ids")
        item.server_ids = item.mongo_server_ids
        item.unset("mongo_server_ids")
        item.save
      end
    end
  end

  def down
  end
end
