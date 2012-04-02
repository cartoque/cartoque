require 'spec_helper'

describe DatabasesHelper do
  before do
    @database = FactoryGirl.create(:database)
  end

  it "should display pretty size" do
    assert_equal "<abbr title=\"1.0Mo\">0.0</abbr>", display_size(1024**2)
    assert_equal "2.5", display_size(2.5*1024**3)
  end

  describe "#databases_summary" do
    it "should return empty string if databases list is empty" do
      assert_equal "", databases_summary([])
    end

    it "should return databases where size >= total_size / 6" do
      databases = {"big_one" => 19, "little_one" => 2, "big_two" => 15, "little_two" => 3}
      assert databases_summary(databases).match(/^big_one, big_two/)
      assert ! databases_summary(databases).include?("little")
    end

    it "should return first two databases if none is greater than total_size / 6" do
      databases = {"big_one" => 2, "big_two" => 2}
      (1..8).each { |i| databases[i.to_s] = 1 }
      assert databases_summary(databases).match(/^big_one, big_two/)
      assert ! databases_summary(databases).include?("little")
    end
  end
end
