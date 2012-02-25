# temp class for active_record versions of objects
class ARApplicationInstance < ActiveRecord::Base
  set_table_name "application_instances"
  has_many "application_urls", foreign_key: "application_instance_id", class_name: "ARApplicationUrl"

  def server_ids
    self.class.connection.execute("SELECT server_id FROM application_instances_servers WHERE application_instance_id = #{self.id};").to_a.flatten
  end
end

class ARApplicationUrl < ActiveRecord::Base
  set_table_name "application_urls"
  belongs_to "application_instance", foreign_key: "application_instance_id", class_name: "ARApplicationInstance"
end

# migration!
class MigrateApplicationInstancesToMongoid < ActiveRecord::Migration
  def up
    add_column :application_instances_servers, :application_instance_mongo_id, :string
    #applications instances with urls
    ApplicationInstance.destroy_all
    cols = ARApplicationInstance.column_names - %w(id application_mongo_id application_id)
    ARApplicationInstance.all.each do |app_instance|
      app = Application.find(app_instance.application_mongo_id) rescue nil
      if app
        attrs = app_instance.attributes.slice(*cols)
        mapp_instance = ApplicationInstance.new(attrs)
        mapp_instance.application = app
        mapp_instance.save
        sql = "UPDATE application_instances_servers SET application_instance_mongo_id='#{mapp_instance.id}' "
        sql << "WHERE application_instance_id = #{app_instance.id};"
        ActiveRecord::Base.connection.execute(sql)
      end
    end
  end

  def down
    #nothing for now
    remove_column :application_instances_servers, :application_instance_mongo_id
  end
end
