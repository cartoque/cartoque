require 'test_helper'

class DatabaseTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert ! Database.new(:name => "blah").valid?
    assert Database.new(:name => "blah", :database_type => "postgres").valid?
  end

  should "return a postgres report" do
    d = Factory(:database)
    assert_not_nil d
    assert d.oracle_report.blank?
    assert d.postgres_report.present?
    assert_equal 2, d.postgres_report.size
    assert_equal 2, d.instances
  end

  should "return an oracle report" do
    d = Factory(:oracle)
    assert_not_nil d
    assert d.oracle_report.present?
    assert d.postgres_report.blank?
    assert_equal 1, d.oracle_report.size
    assert_equal 1, d.instances
  end

  should "return 0 if no report at all" do
    assert_equal 0, Database.new.instances
  end

  should "return a postgres_report if postgres, oracle if oracle, empty array if no database_type" do
    d = Factory(:database)
    assert_equal 2, d.postgres_report.size
    assert_equal 2, d.report.size
    assert_equal [], Database.new.report
  end

  should "return total size handled by a database cluster server" do
    assert_equal 0, Database.new.size
    assert_equal 29313348516, Factory(:database).size
    assert_equal 12091260928, Factory(:oracle).size
  end
end
