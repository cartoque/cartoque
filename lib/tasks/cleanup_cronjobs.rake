desc "Clean up cron jobs depending on tomcats' csv files"
namespace :cleanup do
  task :cronjobs => :environment do
    Dir.glob("data/crons/*.cron").each do |file|
      #server
      server_name = file.split("/").last.gsub(/\.cron$/,"")
      puts "Cleaning Cronjobs for #{server_name}" if ENV['DEBUG'].present?
      server = Server.find_or_generate(server_name)
      if server.blank?
        puts "Skipping Server #{server_name} because it doesn't exist ; you should run 'rake import:cronjobs' or 'rake import:all' first."
      else
        crons_in_database_ids = Cronjob.where(server_id: server.id).map(&:id)
        #cron jobs
        File.readlines(file).each do |line|
          cron = Cronjob.parse_line(line)
          cron.server_id = server.id
          #search existing cronjob
          attrs = cron.attributes.slice(*%w(server_id definition_location command frequency user)).reject{|k,v| v.blank?}
          existing = Cronjob.where(attrs).first
          crons_in_database_ids -= [existing.id] if existing.present?
        end
        if crons_in_database_ids.any?
          puts "Deleting old cronjobs for Server #{server.name}: #{crons_in_database_ids.join(", ")}"
          Cronjob.where(:_id.in => crons_in_database_ids).each(&:destroy)
        end
      end
    end
  end
end
