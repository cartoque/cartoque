# some useful helpers
require 'ar2mongoid'

# temp class for active_record versions of objects
class ARSite < ActiveRecord::Base; set_table_name "sites"; end
class ARServer < ActiveRecord::Base; set_table_name "servers"; end
class ARPhysicalRack < ActiveRecord::Base
  set_table_name "physical_racks"
  has_many :servers, foreign_key: "physical_rack_id", class_name: 'ARServer'
  belongs_to :site, foreign_key: "site_id", class_name: 'ARSite'
end

# migration!
class MigratePhysicalRacksAndSitesToMongodb < ActiveRecord::Migration
  def up
    add_column :servers, :physical_rack_mongo_id, :string
    add_column :servers, :site_mongo_id, :string
    #migrate sites
    cols = ARSite.column_names - %w(id)
    site_map = {}
    ARSite.all.each do |site|
      attrs = site.attributes.slice(*cols)
      msite = Site.create(attrs)
      site_map[site.id] = msite
    end
    #migrates physical racks
    cols = ARPhysicalRack.column_names - %w(id)
    ARPhysicalRack.all.each do |rack|
      attrs = rack.attributes.slice(*cols)
      attrs["site_name"] = rack.site.name
      site = site_map.fetch(attrs.delete("site_id"))
      attrs["site_id"] = site.id if site.present?
      mrack = PhysicalRack.create(attrs)
      ActiveRecord::Base.connection.execute("UPDATE servers SET physical_rack_mongo_id='#{mrack.id}', site_mongo_id='#{mrack.site_id}' WHERE physical_rack_id = #{rack.id}")
    end
  end

  def down
    #nothing for now! maybe a bit of cleanup later?
    remove_column :servers, :physical_rack_mongo_id
    remove_column :servers, :site_mongo_id
  end
end
