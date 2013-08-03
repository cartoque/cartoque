object @application

attributes :id, :name, :description

node(:application_instances) do |appli|
  appli.application_instances.map do |instance|
    { id: instance.id,
      name: instance.name,
      servers: instance.servers,
      application_urls: instance.application_urls.select{|u|u.public?}
    }
  end
end

attributes :dokuwiki_pages

#timestamps
attributes :created_at
attributes :updated_at
