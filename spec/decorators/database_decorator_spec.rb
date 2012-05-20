require 'spec_helper'

describe DatabaseDecorator do
  before do
    @database = FactoryGirl.create(:database).decorate
  end

  it "displays nodes under a database" do
    @database.servers.should be_present
    @database.name.should == "database-01"
    @database.servers.map(&:name).should == %w(server-01)
    pretty = @database.pretty_nodes
    pretty.should have_selector('strong > a', text: @database.name)
    pretty.should have_selector('ul > li', text: @database.servers.first.name)
  end

  it "returns <th> headers depending on the database type" do
    Database.new(type: "postgres").decorate.table_headers.should have_selector('th', text: I18n.t(:postgres_instance))
    Database.new(type: "postgres").decorate.table_headers.should include '</span>' #let's be sure our content is not escaped
    Database.new(type: "oracle").decorate.table_headers.should have_selector('th', text: I18n.t(:oracle_instance))
    Database.new(type: "not valid").decorate.table_headers.should be_nil
  end

  it "returns different columns names depending on the type" do
    Database.new(type: "postgres").decorate.table_column_names.should include "postgres_instance"
    Database.new(type: "oracle").decorate.table_column_names.should include "oracle_instance"
    Database.new(type: "not valid").decorate.table_column_names.should be_nil
  end
end
