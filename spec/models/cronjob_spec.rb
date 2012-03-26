require 'spec_helper'

describe Cronjob do
  describe "Cronjob#parse" do
    it "should parse a simple, standard cron line" do
      line = "00  05  *  *  *  root  /opt/scripts/my-own-script"
      cron = Cronjob.parse_line(line)
      cron.should_not be_valid
      cron.server = Factory(:server)
      cron.should be_valid
      cron.frequency.should eq "00 05 * * *"
      cron.user.should eq "root"
      cron.command.should eq "/opt/scripts/my-own-script"
    end

    it "should parse a cron line with the definition location in first column" do
      line = "/etc/crontab 00  05  *  *  *  root  /opt/scripts/my-own-script"
      cron = Cronjob.parse_line(line)
      cron.should_not be_valid
      cron.server = Factory(:server)
      cron.should be_valid
      cron.definition_location.should eq "/etc/crontab"
      cron.frequency.should eq "00 05 * * *"
      cron.user.should eq "root"
      cron.command.should eq "/opt/scripts/my-own-script"
    end

    it "should parse a cron line with a special frequency" do
      line = "@reboot root  /opt/scripts/my-own-script"
      cron = Cronjob.parse_line(line)
      cron.server_id = Factory(:server).id
      cron.save!
      cron.frequency.should eq "@reboot"
      cron.user.should eq "root"
      cron.command.should eq "/opt/scripts/my-own-script"
    end

    it "should not be valid with 'strongly' invalid cron lines" do
      [ "",
        "      ",
        "less than six elements in line",
        "m h d  m  w  user  command",
        "#* * * * * user commented cron",
        "@rebootz user invalid special frequency"
      ].each do |line|
        Cronjob.parse_line(line).should_not be_valid
      end
    end

    it "should be able to parse a cron file correctly" do
      server = Server.find_or_create_by(name: "server-01")
      crons = File.readlines(File.expand_path("../../data/crons/server-01.cron", __FILE__)).map do |line|
        c = Cronjob.parse_line(line)
        c.server = server
        c
      end
      crons.shift.should_not be_valid
      crons.size.should eq 13
      crons.map(&:valid?).uniq.should eq [true]
    end
  end
end
