class RedmineInstance
  attr_accessor :name, :server, :version, :plugins, :size, :url, :admin,
                :nb_projects, :nb_tickets, :nb_users

  def self.all
    all_instances = []
    files.each do |f|
      begin
        json = JSON.parse(f)
        json.each do |server, components|
          instances = components["redmine"]
          instances.each do |hsh|
            all_instances << new(hsh.merge("server"=>server))
          end
        end
      rescue JSON::ParserError
        Rails.logger.error "Error parsing a JSON file for Redmine"
      end
    end
    all_instances
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
    @admin = hsh["admin"]
    @url = hsh["url"]
    @nb_projects = hsh["nb_projects"].to_i
    @nb_tickets = hsh["nb_tickets"].to_i
    @nb_users = hsh["nb_users"].to_i
    @plugins = hsh["plugins"] || []
  end
end
