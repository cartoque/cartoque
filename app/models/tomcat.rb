class Tomcat < Hash
  def initialize(site,instance = [])
    jdbc_server = site[7].gsub(%r{.*(:jdbc:postgresql://|:jdbc:oracle:thin:@)},"")
    jdbc_db, jdbc_user = site[7].scan(%r{([^/:]+):(\w+)$}).first
    if jdbc_server.present? && jdbc_user.present?
      jdbc_server.gsub!("#{jdbc_db}:#{jdbc_user}","")
      jdbc_server.gsub!(%r{[/:]$},"")
    end
    self.merge!(:server => site[1], :dns => site[2], :vip => site[4],
                :tomcat => site[5], :dir => site[6], :jdbc_url => site[7],
                :jdbc_server => jdbc_server, :jdbc_db => jdbc_db, :jdbc_user => jdbc_user)
    self.merge!(:jdbc_driver => instance[3], :java_version => instance[4],
                :java_xms => instance[5], :java_xmx => instance[6]) if instance.present?
  end

  def self.all
    all = []
    Dir.glob("#{dir}/*.csv").each do |csv|
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
end
