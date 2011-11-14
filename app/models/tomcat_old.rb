class TomcatOld < Hashie::Mash
  def self.from_array(elems)
    tomcat = TomcatOld.new
    #server tomcat pid java xmx xms home : apps
    tomcat.default = ""
    %w(server tomcat pid java xmx xms home).each do |key|
      tomcat[key.to_sym] = elems.shift
    end
    elems.shift
    tomcat.apps = elems.join(" ")
    tomcat
  end

  def self.all
    all = []
    lines = File.read("#{dir}/capistrano.txt").split("\n") rescue []
    lines.shift
    lines.each do |line|
      elems = line.strip.split(/\s+/)
      all << from_array(elems) if elems.size > 7
    end
    all
  end

  def self.dir
    File.expand_path("data/tomcat_old", Rails.root)
  end

  def self.filters_from(tomcats_old)
    filters = Hashie::Mash.new
    filters.tomcat = %w(tomcat4 tomcat5)
    filters.server = tomcats_old.map do |t|
      server = Server.find_by_name(t.server)
      t.server if server.try(:active?) || server.blank?
    end.compact.sort.uniq
    filters
  end
end
