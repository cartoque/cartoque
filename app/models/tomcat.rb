#TODO: move it to Hashie::Dash
class Tomcat < Hashie::Mash
  def initialize(site, instance = [])
    self.default = ""
    jdbc_string = site[7] || ""
    jdbc_server = jdbc_string.gsub(%r{.*(:jdbc:postgresql://|:jdbc:oracle:thin:@)},"")
    jdbc_db, jdbc_user = jdbc_string.scan(%r{([^/:]+):(\w+)$}).first
    if jdbc_server.present? && jdbc_user.present?
      jdbc_server.gsub!("#{jdbc_db}:#{jdbc_user}","")
      jdbc_server.gsub!(%r{[/:]$},"")
    end
    self.merge!(:server => site[1], :dns => site[2], :vip => site[4],
                :tomcat => site[5], :dir => site[6], :jdbc_url => site[7],
                :jdbc_server => jdbc_server, :jdbc_db => jdbc_db, :jdbc_user => jdbc_user)
    self.merge!(:jdbc_driver => instance[3], :java_version => instance[4],
                :java_xms => instance[5], :java_xmx => instance[6]) if instance.present?
    if Tomcat.cerbere_hsh.has_key?(self[:dns])
      self.merge!(:cerbere => true)
      if Tomcat.cerbere_hsh[self[:dns]]
        self.merge!(:cerbere_csac => true)
      else
        self.merge!(:cerbere_csac => false)
      end
    else
      self.merge!(:cerbere => false)
      self.merge!(:cerbere_csac => false)
    end
  end

  def self.all
    all = []
    Dir.glob("#{dir}/*.csv").each do |csv|
      all += from_csv(csv)
    end
    all
  end

  def self.find_for_server(server_name)
    from_csv("#{dir}/#{server_name}.csv")
  end

  def self.from_csv(csv)
    all = []
    if File.exists?(csv)
      lines = File.read(csv).split(/\n/) rescue []
      lines.grep(/^site;/).each do |line|
        site = line.split(";")
        instance = lines.grep(/^instance;/).detect{|i| i.include?("#{site[1]};#{site[5]};")}
        all << new(site, (instance.present? ? instance.split(";") : []))
      end
    end
    all
  end

  def self.dir
    File.expand_path("data/tomcat", Rails.root)
  end

  def self.cerbere_hsh
    File.readlines( File.expand_path("../rp/cerbere.txt", self.dir) ).grep(/Protect/).inject({}) do |hsh,line|
      val = line.scan(/internal host:([^,]+), .*connection (\S+)/).first
      hsh[val.first] = val.last == "ok"
      hsh
    end
  rescue Errno::ENOENT
    {}
  end

  def self.filters_from(tomcats)
    tomcats.inject({}) do |filters,tomcat|
      tomcat.each do |key,value|
        key = key.to_sym
        next if key == :cerbere || key == :cerbere_csac
        filters[key] ||= []
        value = value.split("_").first if key == :tomcat
        filters[key] << value unless filters[key].include?(value)
        filters[key] = filters[key].compact.sort
      end
      filters
    end
  end

  def self.filter_collection(tomcats, params)
    tomcats = tomcats.select{|t| t[:vip].starts_with?(params[:by_vip]) } if params[:by_vip].present?
    tomcats = tomcats.select{|t| t[:server] == params[:by_server]} if params[:by_server].present?
    tomcats = tomcats.select{|t| t[:tomcat].starts_with?(params[:by_tomcat]) } if params[:by_tomcat].present?
    tomcats = tomcats.select{|t| t[:java_version].starts_with?(params[:by_java]) } if params[:by_java].present?
    tomcats
  end
end
