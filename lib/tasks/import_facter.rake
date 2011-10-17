desc "Imports cron jobs from tomcats' csv files"
namespace :import do
  task :facter => :environment do
    Dir.glob("data/system/*.yml").each do |file|
      #server
      server_name = file.split("/").last.gsub(/\.yml$/,"")
      puts "Updating facts for #{server_name}" if ENV['DEBUG'].present?
      server = Server.find_or_generate(server_name)
      puts "Successfully created Server: #{server.name}" if server.just_created
      #facts
      facts = YAML.load_file(file)
      #update facts in server
      %w(rubyversion facterversion puppetversion).each do |key|
        server.send("#{key}=", facts[key]) if facts.has_key?(key)
      end
      os = "#{facts["operatingsystem"]} #{facts["operatingsystemrelease"]}"
      server.operatingsystemrelease = os if os.present?
      server.save if server.changed?
    end
  end
end
