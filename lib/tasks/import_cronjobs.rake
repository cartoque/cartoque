desc "Imports cron jobs from tomcats' csv files"
namespace :import do
  task :cronjobs => :environment do
    #
    # INSERTS NEW CRON JOBS
    #
    Dir.glob("data/tomcat/*.csv").each do |file|
      File.readlines(file).grep(/^cron;/).each do |line|
        #cron;server-01;d;exploit_app;0 4 * * *;root;/apps/app.example.com/script.sh
        elems = line.split(";")
        #create server if needed
        server = Server.find_by_name(elems[1])
        if server.blank?
          server = Server.create(:name => elems[1])
          puts "Successfully created Server: #{server.name}"
        end
        #if enough elements
        hsh = {}
        if elems.size >= 7
          hsh = { :server_id => server.id, :definition_location => elems[2], :name => elems[3],
                  :frequency => elems[4], :user => elems[5], :command => elems[6] }
        end
        #search existing cronjob
        cron = Cronjob.where(hsh.slice(:server_id, :definition_location, :name, :frequency, :user)).first
        #if no, create a new one
        if cron.blank?
          cron = Cronjob.new(hsh)
          if cron.save
            puts "Successfully created cronjob #{cron.name} @ #{cron.server}"
          else
            $stderr.puts "Error creating cronjob: #{cron.inspect}"
          end
        else
          puts "Skipping cronjob #{cron.name} @ #{cron.server}, already exists" if ENV['DEBUG'].present?
        end
      end
    end
  end
end
