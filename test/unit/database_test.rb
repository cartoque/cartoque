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
  end

  should "return an oracle report" do
    d = Factory(:oracle)
    assert_not_nil d
    assert d.oracle_report.present?
    assert d.postgres_report.blank?
    assert_equal 1, d.oracle_report.size
  end
end
