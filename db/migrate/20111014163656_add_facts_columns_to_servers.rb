class AddFactsColumnsToServers < ActiveRecord::Migration
  def change
    add_column :servers, :puppetversion, :string
    add_column :servers, :facterversion, :string
    add_column :servers, :rubyversion, :string
  end
end
