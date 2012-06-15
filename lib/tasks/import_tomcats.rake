desc "Imports tomcats from data/tomcat/*.csv files"
namespace :import do
  task :tomcats => :environment do

    #cerbere
    cerbere_hsh = {}
    begin
      cerbere_hsh = File.readlines('data/rp/cerbere.txt').grep(/Protect/).inject({}) do |hsh,line|
        val = line.scan(/internal host:([^,]+), .*connection (\S+)/).first
        if val && val.first
          hsh[val.first] = (val.last == "ok")
        end
        hsh
      end
    rescue Errno::ENOENT
      {}
    end

    #site;vm-prod-11;salsa.app.ac.cs;salsa.ader.app.ac.cs,;vip-prod-10.ac.cs;TC60_01;/apps/j2ee/salsa.app.ac.cs;salsa:jdbc:postgresql://salsa.sgbd.ac.cs:5434/salsa:salsa;;;;;;;
    #instance;vm-prod-11;TC60_01;lib-SEN;Java160;512;2048
    Dir.glob('data/tomcat/*.csv').each do |csv|

      servername = File.basename(csv).gsub(/\.csv$/, '')
      lines = File.read(csv).split(/\n/) rescue []
      lines.grep(/^site;/).each do |line|

        # 1/ collect data
        site = line.split(";")
        next if site[2].blank? # blank DNS => tomcat not configured
        instance = (lines.grep(/^instance;/).detect{|i| "#{site[1]};#{site[5]};".in?(i) } || "").split(";")

        # 2/ transform/treat
        server = Server.find_or_generate(servername)
        tomcat = Tomcat.find_or_create_by(name: site[5], server_id: server.id)
        tomcat.jdbc_url = site[7] || ""
        #jdbc
        jdbc_server = tomcat.jdbc_url.gsub(%r{.*(:jdbc:postgresql://|:jdbc:oracle:thin:@)},"")
        jdbc_db, jdbc_user = tomcat.jdbc_url.scan(%r{([^/:]+):(\w+)$}).first
        if jdbc_server.present? && jdbc_user.present?
          jdbc_server.gsub!("#{jdbc_db}:#{jdbc_user}","")
          jdbc_server.gsub!(%r{[/:]$},"")
        end
        tomcat.attributes = { jdbc_server: jdbc_server, jdbc_driver: instance[3],
                              jdbc_db: jdbc_db, jdbc_user: jdbc_user }
        #jvm
        tomcat.attributes = { dns: site[2], vip: site[4], dir: site[6],
                              java_version: instance[4], java_xms: instance[5],
                              java_xmx: instance[6] }
        #cerbere
        tomcat.cerbere = cerbere_hsh.has_key?(tomcat.dns)
        tomcat.cerbere_csac = cerbere_hsh[tomcat.dns].present?

        # 3/ associations
        #crons
        definition_mask = Regexp.mask("/exploit_"+tomcat.dns.split(".").first.to_s) 
        tomcat.cronjobs = Cronjob.all_of(server_id: tomcat.server_id, definition_location: definition_mask)

        # 4/ save
        tomcat.save if tomcat.changed?

      end
    end
  end

  def self.filters_from(tomcats)
    filters_from = Hashie::Mash.new
    tomcats.inject(filters_from) do |filters,tomcat|
      tomcat.each do |key,value|
        key = key.to_sym
        server = Server.where(name: value).first
        next if key == :cerbere || key == :cerbere_csac || key == :crons
        next if key == :server && server && !server.active?
        filters[key] ||= []
        value = value.split("_").first if key == :tomcat
        filters[key] << value unless filters[key].include?(value)
        filters[key] = filters[key].compact.sort
      end
      filters
    end
    filters_from.default = []
    filters_from
  end

  def self.filter_collection(tomcats, params)
    tomcats = tomcats.select{|t| t.vip.starts_with?(params[:by_vip]) } if params[:by_vip].present?
    tomcats = tomcats.select{|t| t.server == params[:by_server]} if params[:by_server].present?
    tomcats = tomcats.select{|t| t.tomcat.starts_with?(params[:by_tomcat]) } if params[:by_tomcat].present?
    tomcats = tomcats.select{|t| t.java_version.starts_with?(params[:by_java]) } if params[:by_java].present?
    tomcats
  end
end
