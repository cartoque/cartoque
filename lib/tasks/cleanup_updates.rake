desc "Remove system packages to update when none"
namespace :cleanup do
  task :updates => :environment do
    update_files = Dir.glob("data/update/*").select do |file|
      File.readlines(file).count >= 2
    end.map do |file|
      File.basename(file).gsub(/\.(apt|yum)$/, "")
    end
    # destroy if no update file or server is nil
    Upgrade.includes(:server).each do |upgrade|
      upgrade.destroy if upgrade.server.blank? || !upgrade.server.name.in?(update_files)
    end
  end
end
