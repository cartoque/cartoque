class RTInstance < Hashie::Mash
  def initialize(server, hash)
    self.default = ""
    self.server = server
    hash.each do |k,v|
      self[k] = v
    end
  end

  def self.all
    all = []
    Dir.glob("#{dir}/*.json").map do |json|
      all += from_json(json)
    end
    all
  end

  def self.find_for_server(server_name)
    from_json("#{dir}/#{server_name}.json")
  end

  def self.from_json(json)
    return [] unless File.exists?(json)
    raw = JSON.parse(File.read(json)) rescue []
    raw.map do |hash|
      new(json.split("/").last.gsub(/\.json$/,""), hash)
    end
  end

  def self.dir
    File.expand_path("data/rt", Rails.root)
  end
end
