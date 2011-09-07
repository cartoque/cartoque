class Cron
  unloadable
  attr_accessor :server, :definition_location, :name, :frequency,
                :user, :command

  def self.from_array(elems)
    #%(cron;server-01;d;exploit_app;0 4 * * *;root;/apps/app.example.com/script.sh).split(";")
    cron = Cron.new
    cron.server = elems[1]
    cron.definition_location = elems[2]
    cron.name = elems[3]
    cron.frequency = elems[4]
    cron.user = elems[5]
    cron.command = elems[6]
    cron
  end

  def user
    @user ||= "root"
  end
end
