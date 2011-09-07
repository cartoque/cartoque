require 'test_helper'

class CronTest < ActiveSupport::TestCase
  context "Cron#from_csv_line" do
    setup do
      @line = "cron;server-01;d;exploit_app;0 4 * * *;root;/apps/app.example.com/script.sh"
      @expected = {"server"=>"server-01", "definition_location"=>"d", "name"=>"exploit_app",
                   "frequency"=>"0 4 * * *", "user"=>"root", "command"=>"/apps/app.example.com/script.sh" }
    end

    should "parse line correctly" do
      cron = Cron.from_array(@line.split(";"))
      @expected.each do |key, value|
        assert_equal value, cron.send(key)
      end
    end
  end
end
