# temp class for active_record versions of objects
class ARRole < ActiveRecord::Base
  self.table_name = "roles"
end

# migration!
class MigrateRolesToMongodb < ActiveRecord::Migration
  def up
    Role.destroy_all
    cols = ARRole.column_names - %w(id)
    ARRole.all.each do |role|
      attrs = role.attributes.slice(*cols)
      Role.create(attrs)
    end
  end

  def down
    #nothing for now! maybe a bit of cleanup later?
  end
end
