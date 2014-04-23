collection @databases, root: :databases, object_root: false

attributes :id, :name, :type

node(:server_names) do |database|
  database.servers.map(&:name)
end

if params[:include] && params[:include].include?("servers")
  child :servers do
    extends "servers/show"
  end
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

#timestamps
attributes :created_at
attributes :updated_at
