class CreateContactInfos < ActiveRecord::Migration
  def change
    create_table :contact_infos do |t|
      t.integer :contact_id
      t.string :info_type
      t.string :value
      t.timestamps
    end
  end
end
