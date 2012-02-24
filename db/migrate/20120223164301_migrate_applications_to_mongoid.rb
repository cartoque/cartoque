# temp class for active_record versions of objects
class ARApplication < ActiveRecord::Base
  set_table_name "applications"
end

# migration!
class MigrateApplicationsToMongoid < ActiveRecord::Migration
  def up
    #applications
    add_column :application_instances, :application_mongo_id, :string
    Application.destroy_all
    cols = ARApplication.column_names - %w(id)
    ARApplication.all.each do |app|
      attrs = app.attributes.slice(*cols)
      attrs["ci_identifier"] = attrs.delete("identifier")
      mapp = Application.create(attrs)
      ActiveRecord::Base.connection.execute("UPDATE application_instances SET application_mongo_id='#{mapp.id}' WHERE application_id = #{app.id}")
    end
  end

  def down
    #nothing for now
    remove_column :application_instances, :application_mongo_id
  end
end
