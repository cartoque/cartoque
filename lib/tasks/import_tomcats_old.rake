desc "Imports tomcats from data/tomcat_old/capistrano.txt files"
namespace :import do
  task :tomcats_old => :environment do

    #cerbere
    cerbere_hsh = {}
    begin
      cerbere_hsh = File.readlines('data/rp/cerbere.txt').grep(/Protect/).inject({}) do |hsh,line|
        val = line.scan(/internal host:([^,]+), .*connection (\S+)/).first
        if val && val.first
          hsh[val.first.split(".").first] = (val.last == "ok")
        end
        hsh
      end
    rescue Errno::ENOENT
      {}
    end

    #server tomcat pid java xmx xms home : webapps
    lines = File.readlines('data/tomcat_old/capistrano.txt') rescue []
    lines.shift
    lines.map(&:strip).each do |line|

      server_elements, webapps = line.split(/:/)
      next if server_elements.blank? || webapps.blank?

      servername, name, pid, java, xmx, xms, home = server_elements.strip.split(/\s+/)

      server = Server.find_or_generate(servername)

      webapps.strip.split(/,\s*/).each do |webapp|
        tomcat = Tomcat.find_or_create_by(name: name, server_id: server.id)
        tomcat.attributes = { dns: webapp, dir: home, java_version: java,
                              java_xms: xms, java_xmx: xmx }

        #cerbere
        tomcat.cerbere = cerbere_hsh.has_key?(tomcat.dns)
        tomcat.cerbere_csac = cerbere_hsh[tomcat.dns].present?

        #crons
        definition_mask = Regexp.mask("/exploit_"+tomcat.dns.split(".").first.to_s) 
        tomcat.cronjobs = Cronjob.all_of(server_id: tomcat.server_id, definition_location: definition_mask)

        # save
        tomcat.save if tomcat.changed?
      end
    end
  end
end
