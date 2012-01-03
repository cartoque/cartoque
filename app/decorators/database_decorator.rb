class DatabaseDecorator < ResourceDecorator
  decorates :database

  def pretty_nodes
    html = "<strong>#{h.link_to model.name, model}</strong>"
    if model.servers.any? && model.servers.map(&:name) != [model.name]
      html << %(<ul class="database_nodes">)
      html << model.servers.map(&:name).sort.map{|n| "<li>#{n}</li>"}.join("\n")
      html << "</ul>"
    end
    html.html_safe
  end

  def table_headers
    if model.database_type == "postgres"
      %(<th>IP</th>
        <th>Port</th>
        <th>PgCluster</th>
        <th style="text-align:left;">Bases<span style="float:right;padding-left:1em">Taille(Go)</span></th>).html_safe
    elsif model.database_type == "oracle"
      %(<th>IP</th>
        <th>Port</th>
        <th>Instance</th>
        <th style="text-align:left;">Schemas<span style="float:right;padding-left:1em">Taille(Go)</span></th>).html_safe
    end
  end
end
