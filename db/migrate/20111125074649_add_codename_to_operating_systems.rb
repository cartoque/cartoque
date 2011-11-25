class AddCodenameToOperatingSystems < ActiveRecord::Migration
  def change
    add_column :operating_systems, :codename, :string
  end
end
