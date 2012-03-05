module ApplicationHelper
  include Storcs::Formatter

  def sortable(column, title = nil)
    title ||= t(column, default: column.titleize)
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    link_to title, params.merge(sort: column, direction: direction)
  end

  def sortable_css_class(column)
    column == sort_column ? "current #{sort_direction}" : "sortable"
  end

  def sortable_th(column, title = nil, html_options = {})
    content_tag :th, {class: sortable_css_class(column)}.merge(html_options) do
      sortable(column,title)
    end
  end

  def sortable_link(column, title = nil)
    title ||= t(column, default: column.titleize)
    content_tag :span, class: sortable_css_class(column) do
      sortable(column, title) + content_tag(:span, "", class:"arrow")
    end
  end

  def hidden_sort_fields
    hidden_field_tag(:direction, params[:direction]) +
      hidden_field_tag(:sort, params[:sort])
  end

  def hidden_controller_scopes_fields
    (controller.scopes_configuration || {}).keys.map{|scope| hidden_field_tag scope, params[scope]}.inject(:+)
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

  def sidebar_item(title, url, num = nil)
    html = "".html_safe
    html << content_tag(:div, num, class: "contextual") if num
    html << link_to(title, url)
  end

  def show_version
    link_to("Cartoque", "http://jbbarth.github.com/cartoque/", target: "_blank") + " v#{Cartoque::VERSION}"
  end

  # see ancestry wiki on github
  # usage: <%= f.select :parent_id, @categories %>
  #
  # @categories = ancestry_options(Category.scoped.arrange(order: 'name'){|i| "#{'-'*i.depth} #{i.name}"})
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
        #{object.errors.map do |key,msg|
            "<li>&#171; #{t(key, default: key)} &#187; #{msg}</li>"
          end.join(" ")}
        </ul>
      </td></tr>
      EOF
      html.html_safe
    end
  end

  def action_links(&block)
    content_tag(:div, class: "actions") do
      capture(&block)
    end
  end

  def links_for(application)
    html = ""
    if application.ci_identifier.present?
      html << link_to("R", "#{redmine_url}/projects/#{application.ci_identifier}",
                      title: "Redmine #{application.ci_identifier}", class: "link-to-redmine")
    end
    content_tag(:span, html.html_safe, class: "links")
  end

  def redmine_url
    @redmine_url ||= Setting.redmine_url
  end

  def context_li(text, url, options = {})
    current = options.delete(:current)
    if current
      content_tag :li, text, class: "current"
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
    name + " " + link_to("+", new_server_path(server: { name: name }),
                         class: "action create-server",
                         title: t(:"helpers.submit.create"))
  end

  def link_to_rack(rack)
    return "" if rack.blank?
    link_to rack, servers_path(by_location: "rack-#{rack.id}")
  end

  def link_to_remove_fields(name, f, options = {})
    if options.delete(:confirm)
      js = "if (confirm('#{t(:text_are_you_sure)}')) remove_fields(this)"
    else
      js = "remove_fields(this)"
    end
    f.hidden_field(:_destroy) + link_to_function(name, js, {class: "link-delete"}.merge(options)).html_safe
  end

  def link_to_add_fields(name, f, association, extra_params = {})
    new_object = (extra_params.delete(:klass) || f.object.class.reflect_on_association(association).klass).new
    fields = f.fields_for(association, new_object, child_index: "new_#{association}") do |builder|
      render(association.to_s.singularize + "_fields", {f: builder}.merge(extra_params))
    end
    link_to_function(name, "add_fields(this, \"#{association}\", \"#{escape_javascript(fields)}\")", class: "link-add")
  end

  def link_to_edit(path)
    link_to image_tag("edit.png", size: "16x16", class: "action"), path
  end

  def link_to_delete(resource)
    confirmation = resource.respond_to?(:name) ? t(:text_confirm_delete, element: resource.name) : t(:text_are_you_sure)
    link_to image_tag("delete.png", size: "16x16", class: "action"), resource,
            confirm: confirmation, method: :delete, title: "Delete #{resource.class.name.parameterize} #{resource.to_param}"
  end

  def current_announcement
    return @current_announcement if defined?(@current_announcement)
    hide_time = current_user.settings["announcement_hide_time"]
    if hide_time
      if Setting.site_announcement_updated_at > hide_time
        @current_announcement = Setting.site_announcement_message
      else
        @current_announcement = nil
      end
    else
      @current_announcement = Setting.site_announcement_message
    end
    @current_announcement
  end

  def link_to_website(website)
    website.strip!
    target = website
    target = "http://"+target unless target.match(%r(^\w+://))
    link_to website, target
  end
end
