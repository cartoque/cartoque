class RemoveStaticContactInfosFromContacts < ActiveRecord::Migration
  def up
    remove_column :contacts, :phone
    remove_column :contacts, :mobile
    remove_column :contacts, :email
  end

  def down
    add_column :contacts, :email, :string
    add_column :contacts, :mobile, :string
    add_column :contacts, :phone, :string
  end
end
