desc "Imports licenses from json files"
namespace :import do
  task :licenses => :environment do
    Dir.glob("data/licenses/*.json").each do |file|
      type = file.split("/").last.gsub(/\.json$/, "")
      json = JSON.load(File.read(file)) rescue nil
      next if json.blank?
      json.each do |hsh|
        editor = hsh["editor"] || type
        license = License.find_or_create_by(editor: editor, key: hsh["key"])
        license.update_attributes(hsh.slice("title", "quantity"))
        license.servers = hsh["servers"].map do |server_name|
          Server.find_or_generate(server_name)
        end
        license.save if license.changed?
      end
    end
  end
end
