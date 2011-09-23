desc "Imports cron jobs from tomcats' csv files"
namespace :import do
  task :cronjobs => :environment do
    Dir.glob("data/crons/*.cron").each do |file|
      #server
      server_name = file.split("/").last.gsub(/\.cron$/,"")
      puts "Updating Cronjobs for #{server_name}" if ENV['DEBUG'].present?
      server = Server.find_or_generate(server_name)
      puts "Successfully created Server: #{server.name}" if server.just_created
      #cron jobs
      File.readlines(file).each do |line|
        cron = Cronjob.parse_line(line)
        cron.server_id = server.id
        #loop if nothing ; invalid cron
        puts "Invalid cron #{server_name} -> #{line}" if !cron.valid? && ENV['DEBUG'].present?
        next unless cron.valid?
        #search existing cronjob
        attrs = cron.attributes.slice(*%w(server_id definition_location command frequency user)).reject{|k,v| v.blank?}
        existing = Cronjob.where(attrs).first
        existing ||= Cronjob.where(attrs.slice(*%w(server_id command frequency user)).merge(:definition_location => nil)).first
        #if no, create a new one
        if existing.blank?
          if cron.save
            puts "Successfully created cronjob #{cron.definition_location} @ #{cron.server}"
          else
            $stderr.puts "Error creating cronjob: #{cron.inspect}"
          end
        else
          attr_keys = %w(server_id definition_location command frequency user)
          if cron.attributes.slice(*attr_keys) != existing.attributes.slice(*attr_keys)
            existing.update_attributes(cron.attributes.slice(*attr_keys))
            puts "Updating cronjob #{existing.definition_location} @ #{existing.server}"
          else
            puts "Skipping cronjob #{existing.definition_location} @ #{existing.server}, already exists" if ENV['DEBUG'].present?
          end
        end
      end
    end
  end
end
