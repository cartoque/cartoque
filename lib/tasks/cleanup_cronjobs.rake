desc "Clean up cron jobs depending on tomcats' csv files"
namespace :cleanup do
  task :cronjobs => :environment do
    #
    # CLEANUP CRON JOBS
    #
    Dir.glob("data/tomcat/*.csv").each do |file|
      crons = File.readlines(file).grep(/^cron;/)
      if crons.any?
        #cron;server-01;d;exploit_app;0 4 * * *;root;/apps/app.example.com/script.sh
        server_name = crons.first.split(";")[1]
        server = Server.find_by_name(server_name)
        if server.blank?
          puts "Skipping Server #{server_name} because it doesn't exist ; you should run 'rake import:cronjobs' or 'rake import:all' first."
        else
          crons_in_database_ids = Cronjob.where(:server_id => server.id).map(&:id)
          crons.each do |line|
            elems = line.split(";")
            hsh = { :server_id => server.id, :definition_location => "/etc/cron.#{elems[2]}/#{elems[3]}",
                    :frequency => elems[4], :user => elems[5], :command => elems[6..-1] }
            cron = Cronjob.where(hsh.slice(:server_id, :definition_location, :frequency, :user)).first
            crons_in_database_ids -= [cron.id] if cron.present?
          end
          if crons_in_database_ids.any?
            puts "Deleting old cronjobs for Server #{server.name}: #{crons_in_database_ids.join(", ")}"
            Cronjob.where(:id => crons_in_database_ids).each(&:destroy)
          end
        end
      end
    end
  end
end
