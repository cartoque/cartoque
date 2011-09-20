require 'test_helper'

class CronjobTest < ActiveSupport::TestCase
  context "#parse" do
    should "parse a simple, standard cron line" do
      line = "00  05  *  *  *  root  /opt/scripts/my-own-script"
      cron = Cronjob.parse_line(line)
      assert !cron.valid?
      cron.server_id = Factory(:server).id
      assert cron.valid?
      assert_equal "00 05 * * *", cron.frequency
      assert_equal "root", cron.user
      assert_equal "/opt/scripts/my-own-script", cron.command
    end

    should "parse a cron line with the definition location in first column" do
      line = "/etc/crontab 00  05  *  *  *  root  /opt/scripts/my-own-script"
      cron = Cronjob.parse_line(line)
      assert !cron.valid?
      cron.server_id = Factory(:server).id
      assert cron.valid?
      assert_equal "/etc/crontab", cron.definition_location
      assert_equal "00 05 * * *", cron.frequency
      assert_equal "root", cron.user
      assert_equal "/opt/scripts/my-own-script", cron.command
    end

    should "not be valid with 'strongly' invalid cron lines" do
      [ "",
        "      ",
        "less than six elements in line",
        "m h d  m  w  user  command",
        "#* * * * * user commented cron"
      ].each do |line|
        assert !Cronjob.parse_line(line).valid?
      end
    end

    should "be able to parse a cron file correctly" do
      server = Server.find_or_create_by_name("server-01")
      crons = File.readlines(File.expand_path("../../data/crons/server-01.cron", __FILE__)).map do |line|
        c = Cronjob.parse_line(line)
        c.server = server
        c
      end
      assert ! crons.shift.valid?
      assert_equal 13, crons.size
      assert_equal [true], crons.map(&:valid?).uniq
    end
  end
end
