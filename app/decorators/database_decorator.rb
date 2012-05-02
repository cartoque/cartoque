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

  def table_headers(view_mode = "normal")
    if view_mode == "normal" || view_mode == "detailed"
      normal_table_headers
    elsif view_mode == "parameters"
      parameters_table_headers
    else
      raise ArgumentError, "should be among 'detailed', 'normal', 'parameters'"
    end
  end

  def normal_table_headers
    labels = table_column_names
    if labels
      html = "".html_safe
      labels.first(3).each do |label|
        html << h.content_tag(:th, t(label))
      end
      html << h.content_tag(:th, style: "text-align:left;") do
        ERB::Util.h(t(labels[3])).html_safe +
          h.content_tag(:span, t(labels[4]), style: "float:right;padding-left:1em")
      end 
      html
    end
  end

  def parameters_table_headers
    html = "".html_safe
    html << h.content_tag(:th, "Version")
    html << h.content_tag(:th, colspan: 3, style: "text-align:left;") do
      "Param".html_safe + h.content_tag(:span, "Value", style: "float:right;padding-left:1em")
    end 
    html
  end

  def table_column_names
    if model.type == "postgres"
      %w(ip port postgres_instance postgres_items size_in_GB)
    elsif model.type == "oracle"
      %w(ip port oracle_instance oracle_items size_in_GB)
    end
  end
end
