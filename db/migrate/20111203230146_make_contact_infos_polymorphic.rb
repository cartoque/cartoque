class MakeContactInfosPolymorphic < ActiveRecord::Migration
  def change
    rename_column :contact_infos, :contact_id, :entity_id
    add_column :contact_infos, :entity_type, :string
  end
end
