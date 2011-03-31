# encoding: utf-8

module DatabasesHelper
  def database_nodes(database)
    html = "<strong>#{link_to database.name, database}</strong>"
    if database.machines.any? && database.machines.map(&:nom) != [database.name]
      html << %(<ul class="database_nodes">)
      html << database.machines.map(&:nom).sort.map{|n| "<li>#{n}</li>"}.join("\n")
      html << "</ul>"
    end
    html.html_safe
  end

  def database_headers_for(database_type)
    if database_type == "postgres"
      %(<th>PgCluster</th>
        <th>IP:Port</th>
        <th style="text-align:left;">Bases<span style="float:right;padding-left:1em">Taille(Go)</span></th>
        <th>Stockage</th>).html_safe
    elsif database_type == "oracle"
      %(<th>Instance</th>
        <th>IP:Port</th>
        <th style="text-align:left;">Schémas<span style="float:right;padding-left:1em">Taille(Go)</span></th>
        <th>Stockage</th>).html_safe
    end
  end

  def display_size(size)
    html = size_in_Go(size)
    if html.to_f <= 1
      html = %(<abbr title="#{size_in_Mo(size)}Mo">#{html}</abbr>)
    end
    html.to_s.html_safe
  end

  def size_in_Go(size)
    "%.1f" % (size / 1024.0**3)
  end

  def size_in_Mo(size)
    "%.1f" % (size / 1024.0**2)
  end
end
