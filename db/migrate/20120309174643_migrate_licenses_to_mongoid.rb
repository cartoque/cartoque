# temp class for active_record versions of objects
class ARLicense < ActiveRecord::Base
  self.table_name = "licenses"
end

# migration!
class MigrateLicensesToMongoid < ActiveRecord::Migration
  def up
    add_column :licenses_servers, :license_mongo_id, :string
    License.destroy_all
    cols = ARLicense.column_names - %w(id)
    ARLicense.all.each do |lic|
      attrs = lic.attributes.slice(*cols)
      mlic = License.create(attrs)
      ActiveRecord::Base.connection.execute("UPDATE licenses_servers SET license_mongo_id='#{mlic.id}' WHERE license_id = #{lic.id}")
    end
  end

  def down
    remove_column :licenses_servers, :license_mongo_id
    #nothing else for now! maybe a bit of cleanup later?
  end
end
