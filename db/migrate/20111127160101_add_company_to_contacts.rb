class AddCompanyToContacts < ActiveRecord::Migration
  def up
    add_column :contacts, :company_id, :integer
    remove_column :contacts, :company
  end

  def down
    add_column :contacts, :company, :string
    remove_column :contacts, :company_id
  end
end
