class DatabaseInstanceImporter
  attr_accessor :name

  def initialize(server_name)
    @name = server_name
  end

  def self.safe_json_parse(file, default_value = [])
    if File.exists?(file)
      begin
        JSON.parse(File.read(file))
      rescue JSON::ParserError => e
        default_value
      end
    else
      default_value
    end
  end
end

desc "Imports databases from data/(oracle|postgres)/* files"
namespace :import do
  task :databases => :environment do
    #create database services if server exist
    (Dir.glob("data/postgres/*") + Dir.glob("data/oracle/*")).each do |filename|
      db_type, db_name = filename.scan(%r[data/(oracle|postgres)/(.*).txt]).first
      next unless File.size(filename) > 0  #empty file
      next unless File.size(filename) > 10 #file with potential data in
      db = Database.where(name: db_name, type: db_type).first
      next if db.present? && db.servers.present?
      server = Server.where(name: db_name).first
      next unless server
      next if server.database.present?
      if db.present?
        Database.create(name: db_name, type: db_type, servers: [server])
      else
        db.servers = [server]
        db.save
      end
    end
    #import database files
    Database.all.each do |db|
      files = db.servers.map(&:name).map do |server_name|
        File.expand_path("data/#{db.type}/#{server_name.downcase}.txt", Rails.root)
      end.select do |file|
        File.exists?(file)
      end
      reports = files.map do |file|
        DatabaseInstanceImporter.safe_json_parse(file, [])
      end.flatten
      #NB: in a DatabaseInstance, listen ip+listen port+name is unique
      #add non existing reports / update existing
      reports.each do |report|
        dbi = db.database_instances.find_or_create_by(name: report["pg_cluster"] || report["ora_instance"],
                                                      listen_address: report["ip"],
                                                      listen_port: report["port"].to_i)
        dbi.host_alias = report["host"]
        dbs = report["schemas"].presence || report["databases"].presence
        dbi.databases = dbs if dbs.present?
        dbi.version = report["version"] if report["version"].present?
        dbi.config = report["config"] if report["config"].present?
        dbi.set_updated_at
        dbi.save
      end
      #remove old ones if older than 1 week
      db.database_instances.where(:updated_at.lt => Date.today - 1.week).each(&:destroy)
    end
  end
end
