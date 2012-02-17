# some useful helpers
require 'ar2mongoid'

# temp class for active_record physical_racks
class ARPhysicalRack < ActiveRecord::Base
  set_table_name "physical_racks"

  has_many :servers, foreign_key: "physical_rack_id"
  belongs_to :site
end

# temp class for mongoid physical_racks
class MongoPhysicalRack
  include Mongoid::Document
  store_in "physical_racks"

  ARPhysicalRack.columns.each do |column|
    field_name = (column.name == "id" ? "active_record_id" : column.name)
    field field_name.to_sym, type: AR2Mongoid.mongoid_type(column)
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
      attrs["active_record_id"] = attrs.delete("id")
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
