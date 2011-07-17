class TomcatOld < Hash
  def initialize(elems)
    #server tomcat pid java xmx xms home : apps
    self.default = ""
    %w(server tomcat pid java xmx xms home).each do |key|
      self[key.to_sym] = elems.shift
    end
    elems.shift
    self[:apps] = elems.join(" ")
  end

  def self.all
    all = []
    lines = File.read("#{dir}/capistrano.txt").split("\n") rescue []
    lines.shift
    lines.each do |line|
      elems = line.strip.split(/\s+/)
      all << new(elems) if elems.size > 7
    end
    all
  end

  def self.dir
    File.expand_path("data/tomcat_old", Rails.root)
  end

  def self.filters_from(tomcats_old)
    filters = {}
    filters[:tomcat] = %w(tomcat4 tomcat5)
    filters[:server] = tomcats_old.map{|t| t[:server]}.compact.sort.uniq
    filters
  end
end
