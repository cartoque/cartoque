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
      %(<th>#{t(:ip)}</th>
        <th>#{t(:port)}</th>
        <th>#{t(:postgres_instance)}</th>
        <th style="text-align:left;">#{t(:postgres_items)}<span style="float:right;padding-left:1em">#{t(:size_in_GB)}</span></th>).html_safe
    elsif model.database_type == "oracle"
      %(<th>#{t(:ip)}</th>
        <th>#{t(:port)}</th>
        <th>#{t(:oracle_instance)}</th>
        <th style="text-align:left;">#{t(:oracle_items)}<span style="float:right;padding-left:1em">#{t(:size_in_GB)}</span></th>).html_safe
    end
  end
end
