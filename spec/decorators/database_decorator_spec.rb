require 'spec_helper'

describe DatabaseDecorator do
  before do
    @database = Factory(:database).decorate
  end

  it "should display nodes under a database" do
    assert @database.servers.present?
    assert_equal "database-01", @database.name
    assert_equal "server-01", @database.servers.map(&:name).join(" ")
    pretty = @database.pretty_nodes
    pretty.should have_selector('strong > a', :text => @database.name)
    pretty.should have_selector('ul > li', :text => @database.servers.first.name)
  end

  it "should return <th> headers depending on the database" do
    Database.new(:database_type => "postgres").decorate.table_headers.should have_selector('th', :text => 'PgCluster')
    Database.new(:database_type => "oracle").decorate.table_headers.should have_selector('th', :text => 'Instance')
    Database.new(:database_type => "not valid").decorate.table_headers.should be_nil
  end
end
