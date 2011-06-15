class RedmineInstance
  attr_accessor :name, :server, :version, :size

  def self.all
    return @instances if defined?(@instances)
    @instances = []
    files.each do |f|
      begin
        json = JSON.parse(f)
        json.each do |server, components|
          instances = components["redmine"]
          instances.each do |hsh|
            @instances << new(hsh.merge("server"=>server))
          end
        end
      rescue JSON::ParserError
        Rails.logger.error "Error parsing a JSON file for Redmine"
      end
    end
    @instances
  end

  def self.files
    Dir.glob(dir+"/*").map{|f| File.read(f) if File.file?(f)}.compact
   end

  def self.dir
    Rails.root.join("data/redmine").to_s
  end

  def initialize(hsh)
    @name = hsh["name"]
    @server = hsh["server"]
    @version = hsh["version"]
    @size = hsh["size"].to_i
  end
end
