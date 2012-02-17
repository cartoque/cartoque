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

# temp class for mongoid physical_racks
class MongoPhysicalRack
  include Mongoid::Document
  store_in "physical_racks"

  ARPhysicalRack.columns.each do |column|
    unless column.name == "id"
      field column.name.to_sym, type: AR2Mongoid.mongoid_type(column)
    end
  end
  field :site_name, type: String
end

class MigratePhysicalRacksToMongodb < ActiveRecord::Migration
  def up
    add_column :servers, :physical_rack_mongo_id, :string
    add_column :servers, :site_id, :integer
    cols = ARPhysicalRack.column_names.select{|c| c != "id"}
    ARPhysicalRack.all.each do |rack|
      attrs = rack.attributes.slice(*cols)
      attrs["site_name"] = rack.site.name
      mrack = MongoPhysicalRack.create(attrs)
      ActiveRecord::Base.connection.execute("UPDATE servers SET physical_rack_mongo_id='#{mrack.id}', site_id=#{rack.site_id} WHERE physical_rack_id = #{rack.id}")
    end
  end

  def down
    #nothing for now! maybe a bit of cleanup later?
    remove_column :servers, :physical_rack_mongo_id
    remove_column :servers, :site_id
  end
end
