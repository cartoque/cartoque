class AddInternalToCompaniesAndContacts < ActiveRecord::Migration
  def change
    add_column :companies, :internal, :boolean, default: false
    add_column :contacts, :internal, :boolean, default: false
  end
end
