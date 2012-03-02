# some useful helpers
require 'ar2mongoid'

# temp class for active_record versions of objects
class ARDatacenter < ActiveRecord::Base
  set_table_name "datacenters"
end

# migration!
class MigrateDatacentersToMongodb < ActiveRecord::Migration
  def up
    Datacenter.destroy_all
    cols = ARDatacenter.column_names - %w(id)
    ARDatacenter.all.each do |datacenter|
      attrs = datacenter.attributes.slice(*cols)
      Datacenter.create(attrs)
    end
  end

  def down
    #nothing for now! maybe a bit of cleanup later?
  end
end
