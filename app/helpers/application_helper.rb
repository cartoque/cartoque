module ApplicationHelper
  include Storcs::Formatter

  def sortable(column, title = nil)
    title ||= t(column, :default => column.titleize)
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    link_to title, params.merge(:sort => column, :direction => direction)
  end

  def sortable_css_class(column)
    column == sort_column ? "current #{sort_direction}" : "sortable"
  end

  def sortable_th(column, title = nil, html_options = {})
    content_tag :th, {:class => sortable_css_class(column)}.merge(html_options) do
      sortable(column,title)
    end
  end

  def progress_bar(pcts, options={})
    #width
    width = 120
    if options[:width].present? && options[:width].is_a?(Integer)
      width = options[:width]
    end
    width = width.to_f
    #percents calculations
    pcts = [pcts, pcts] unless pcts.is_a?(Array)
    pcts = pcts.collect(&:round)
    pcts[1] = pcts[1] - pcts[0]
    pcts.map! do |pct|
      pct * width / 100
    end
    pcts << (width - pcts[1] - pcts[0])
    legend = options[:legend] || ''
    o = %(<table class="progress" style="width:#{width + 30}px;"><tr>)
    o << %(<td class="closed" style="width:#{pcts[0]}px;"></td>) if pcts[0] > 0
    o << %(<td class="done" style="width:#{pcts[1]}px;"></td>) if pcts[1] > 0
    o << %(<td class="todo" style="width:#{pcts[2]}px;"></td>) if pcts[2] > 0
    o << %(<td class="legend" style="width:30px">#{legend}</td>)
    o << %(</tr></table>)
    o.html_safe
  end

  def show_version
    "<i>Cartoque v#{Cartocs::VERSION}</i>".html_safe
  end

  # see ancestry wiki on github
  # usage: <%= f.select :parent_id, @categories %>
  #
  # @categories = ancestry_options(Category.scoped.arrange(:order => 'name'){|i| "#{'-'*i.depth} #{i.name}"})
  def ancestry_options(items, &block)
    result = []
    items.map do |item, sub_items|
      result << [ yield(item), item.id ]
      #recursive call
      result += ancestry_options(sub_items) {|i| "#{'-'*i.depth} #{i.name}" }
    end
    result
  end

  def tabular_errors(object)
    if object.errors.any?
      html = <<-EOF
      <tr id="error_explanation"><td colspan="2">
        <h2>#{pluralize(object.errors.count, "erreur")} :</h2>
        <ul>
        #{object.errors.full_messages.map do |msg|
            "<li>"+msg+"</li>"
          end.join(" ")}
        </ul>
      </td></tr>
      EOF
      html.html_safe
    end
  end

  def action_links(&block)
    content_tag(:div, :class => "actions") do
      capture(&block)
    end
  end

  def links_for(application)
    html = ""
    if application.identifier?
      html << link_to("R", (URI.parse(APP_CONFIG[:redmine_url])+"/projects/#{application.identifier}").to_s,
                      :title => "Redmine #{application.identifier}", :class => "link-to-redmine")
    end
    content_tag(:span, html.html_safe, :class => "links")
  end

  def display_server(server)
    content_tag(:span, :class => "server-link") do
      link_to(server.name, server) + content_tag(:span, :class => "server-details") do
        [ server.operating_system,
          (server.nb_proc && server.nb_proc > 0 ? server.cores : ""),
          (server.memory? ? "#{server.ram}G" : ""),
          (server.disk_size && server.disk_size > 0 ? server.disks : "") ].reject(&:blank?).join(" | ")
      end
    end
  end

  def context_li(text, url, options = {})
    current = options.delete(:current)
    if current
      content_tag :li, text, :class => "current"
    else
      content_tag :li, link_to(text, url, options)
    end
  end

  def link_to_servername(name)
    link_to name, server_path(Server.identifier_for(name))
  end

  def link_to_server_if_exists(name)
    s = Server.find_by_name(name)
    s ? link_to(name, s) : server_missing(name)
  end

  def server_missing(name)
    name + " " + link_to("+", new_server_path(:server => { :name => name }),
                         :class => "action create-server",
                         :title => t(:"helpers.submit.create"))
  end

  def link_to_rack(rack)
    return "" if rack.blank?
    link_to rack, servers_path(:by_location => "rack-#{rack.id}")
  end

  def link_to_remove_fields(name, f, options = {})
    if options.delete(:confirm)
      js = "if (confirm('#{t(:text_are_you_sure)}')) remove_fields(this)"
    else
      js = "remove_fields(this)"
    end
    f.hidden_field(:_destroy) + link_to_function(name, js, {:class => "link-delete"}.merge(options)).html_safe
  end

  def link_to_add_fields(name, f, association)
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      render(association.to_s.singularize + "_fields", :f => builder)
    end
    link_to_function(name, "add_fields(this, \"#{association}\", \"#{escape_javascript(fields)}\")", :class => "link-add")
  end
end
