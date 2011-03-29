module DatabasesHelper
  def database_nodes(database)
    html = "<strong>#{database.name}</strong>"
    if database.machines.any? && database.machines.map(&:nom) != [database.name]
      html << %(<ul class="database_nodes">)
      html << database.machines.map(&:nom).sort.map{|n| "<li>#{n}</li>"}.join("\n")
      html << "</ul>"
    end
    html.html_safe
  end
end
