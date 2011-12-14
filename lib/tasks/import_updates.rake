desc "Imports system packages to update"
namespace :import do
  task :updates => :environment do
    # ONLY APT FILES FOR NOW !!!!!!
    Dir.glob("data/update/*.txt").each do |file|
      servername = File.basename(file).gsub(/\.txt$/, "")
      server = Server.find_or_generate(servername)
      packages = File.readlines(file).grep(/ => /).map(&:strip).map do |line|
        if line.match /^(\S+)\s+\((\S+) => (\S+)\)/
          #puts "server:#{servername}, package:#{$1}, from:#{$2}, to:#{$3}"
          pkg = {name: $1, old: $2, new: $3}
          name = pkg[:name]
          status = "normal"
          status = "needing_reboot" if name.match(/^linux-(base|image)/)
          status = "important" if name.match(/^apache2|^bind9(-|$)|^firmware-|^heartbeat/)
          status = "important" if name.match(/^ldirector|^libc\d|-(scn|sen)$|^mysql-server/)
          status = "important" if name.match(/^openssh-server|^php5|^postfix|^postgresql-\d/)
          status = "important" if name.match(/^puppet$/)
          pkg[:status] = status
          pkg
        end
      end.compact
      upgrade = Upgrade.find_or_create_by_server_id_and_strategy(server.id, "apt")
      upgrade.packages_list = packages
      upgrade.save if upgrade.changed?
    end
  end
end
