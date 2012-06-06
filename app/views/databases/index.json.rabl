collection @databases => :databases

attributes :id, :name, :type

node(:server_names) do |database|
  database.servers.map(&:name)
end

node(:instances) do |database|
  database.database_instances.select do |inst|
    inst.databases.present?
  end.map do |inst|
    { id: inst.id,
      name: inst.name,
      listen_address: inst.listen_address,
      listen_port: inst.listen_port,
      host_alias: inst.host_alias,
      version: inst.version
    }
  end
end
