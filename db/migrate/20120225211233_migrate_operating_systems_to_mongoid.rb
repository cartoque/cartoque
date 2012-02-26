# temp class for active_record versions of objects
class AROperatingSystem < ActiveRecord::Base
  set_table_name "operating_systems"
end

# migration!
class MigrateOperatingSystemsToMongoid < ActiveRecord::Migration
  def up
    #applications
    add_column :servers, :operating_system_mongo_id, :string
    OperatingSystem.destroy_all
    cols = AROperatingSystem.column_names - %w(id icon_path ancetry ancestry_depth)
    #first shot to draw a map of {id=>mongo_id}
    sysmap = {}
    parentmap = {}
    AROperatingSystem.all.each do |sys|
      attrs = sys.attributes.slice(*cols)
      msys = OperatingSystem.create(attrs)
      sysmap[sys.id] = msys.id
      parentmap[sys.id] = sys.ancestry.to_s.split("/").last
      ActiveRecord::Base.connection.execute("UPDATE servers SET operating_system_mongo_id='#{msys.id}' WHERE operating_system_id = #{sys.id}")
    end
    #second shot to effectively set ancestries
    sysmap.each do |sys_id,msys_id|
      parent_ar_id = parentmap[sys_id]
      if parent_ar_id.present?
        parent_mongo_id = sysmap[parent_ar_id.to_i]
        msys = OperatingSystem.find(msys_id)
        msys.parent_id = parent_mongo_id
        msys.save
      end
    end
  end

  def down
    #nothing for now
    remove_column :servers, :operating_system_mongo_id
  end
end
