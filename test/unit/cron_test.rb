require 'test_helper'

class CronTest < ActiveSupport::TestCase
  context "Cron#from_array" do
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

  context "#==" do
    setup do
      @array1 = "cron;vm-01;d;exploit_app01;0 3 * * *;exploit;/opt/chroot/www/apps/batch/app01.example.com/purge/purge_files.sh".split(";")
      @array2 = "cron;vm-01;d;exploit_app01;0 5 * * *;exploit;/opt/chroot/www/apps/batch/app01.example.com/purge/purge_files2.sh".split(";")
    end
    
    should "be equal to itself (not that hard!)" do
      cron = Cron.from_array(@array1)
      assert cron == cron
    end

    should "be equal to other with same parameters" do
      cron1 = Cron.from_array(@array1)
      cron2 = Cron.from_array(@array1)
      assert cron1 == cron2
    end

    should "not be equal with a different cron" do
      cron1 = Cron.from_array(@array1)
      cron2 = Cron.from_array(@array2)
      assert cron1 != cron2
    end
  end
end
