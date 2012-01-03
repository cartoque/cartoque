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

###  it "should display pretty size" do
###    assert_equal "<abbr title=\"1.0Mo\">0.0</abbr>", display_size(1024**2)
###    assert_equal "2.5", display_size(2.5*1024**3)
###  end

###  describe "#databases_summary" do
###    it "should return empty string if databases list is empty" do
###      assert_equal "", databases_summary([])
###    end

###    it "should return databases where size >= total_size / 6" do
###      databases = {"big_one" => 19, "little_one" => 2, "big_two" => 15, "little_two" => 3}
###      assert databases_summary(databases).match(/^big_one, big_two/)
###      assert ! databases_summary(databases).include?("little")
###    end

###    it "should return first two databases if none is greater than total_size / 6" do
###      databases = {"big_one" => 2, "big_two" => 2}
###      (1..8).each { |i| databases[i.to_s] = 1 }
###      assert databases_summary(databases).match(/^big_one, big_two/)
###      assert ! databases_summary(databases).include?("little")
###    end
###  end
###end
###  def database_headers_for(database_type)
###    if database_type == "postgres"
###      %(<th>IP</th>
###        <th>Port</th>
###        <th>PgCluster</th>
###        <th style="text-align:left;">Bases<span style="float:right;padding-left:1em">Taille(Go)</span></th>).html_safe
###    elsif database_type == "oracle"
###      %(<th>IP</th>
###        <th>Port</th>
###        <th>Instance</th>
###        <th style="text-align:left;">Schémas<span style="float:right;padding-left:1em">Taille(Go)</span></th>).html_safe
###    end
###  end

###  def databases_summary(databases)
###    return "" if databases.blank?
###    total_size = databases.values.sum
###    top_databases = databases.select do |db,size|
###      size >= total_size / 6
###    end.keys
###    if top_databases.size == 0
###      top_databases = databases.sort_by do |db,size|
###        size
###      end.reverse.map do |a|
###        a[0]
###      end.first(2)
###    end
###    html = %(#{top_databases.join(", ")})
###    html << %(,&nbsp;...) if top_databases.size < databases.size
###    html << %(<span style="float:right; padding-left:1em">#{display_size(total_size)}</span>)
###    html.html_safe
###  end
end
