class MigrateExistingMaintainers < ActiveRecord::Migration
  def up
    #return if !table_exists?("mainteneurs") || !columns("servers").map(&:name).include?("mainteneur_id")
    
    conn = ActiveRecord::Base.connection
    #create a column in servers to record maintainer_id
    #/!\ "maintainer_id"(new) != "mainteneur_id"(old)
    add_column :servers, :maintainer_id, :integer
    #first collect actual servers<->maintainers records
    maintenances = conn.select_all("SELECT id, mainteneur_id FROM servers;")
    #then build a hash of {maintainer1_id => [server1_id, server2_id], maintainer2_id => ...}
    maintainers_servers = maintenances.inject({}) do |memo,hsh|
      memo[hsh["mainteneur_id"]] ||= []
      memo[hsh["mainteneur_id"]] << hsh["id"]
      memo
    end
    #finally iterate on maintainers in "mainteneurs" table, and for each one, create a 'company' if needed, and associate servers with it
    mainteneurs = conn.select_all("SELECT * FROM mainteneurs;")
    mainteneurs.each do |mainteneur|
      begin
        company = Company.find_or_create_by_name(mainteneur["name"])
      rescue
        $stderr.puts "ERROR: unable to import #{mainteneur["name"]}"
      end
      if company.present?
        maintainers_servers[mainteneur["id"]].each do |server_id|
          begin
            Server.find(server_id).update_attribute("maintainer_id", company.id)
          rescue
            $stderr.puts "ERROR: unable to set maintainer=#{mainteneur["name"]} for server #{server_id}"
          end
        end
      end
    end
  end

  def down
    remove_column :servers, :maintainer_id
    #nothing more here, we don't look back!
  end
end
