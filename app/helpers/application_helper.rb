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

  def sortable_th(column, title = nil)
    %(<th class="#{sortable_css_class(column)}">#{sortable(column,title)}</th>).html_safe
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

  def nested_select_tag(klass, form, object, idkey, namekey)
    collection = klass.order("path_cache, #{namekey}")
    collection -= object.subtree unless object.blank? || object.new_record?
    form.input idkey, :as => :select, :collection => collection.map { |o| ["-" * o.depth + " " + o.send(namekey), o.id] }
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
    content_tag(:p, :class => "actions") do
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

  def display_machine(machine)
    content_tag(:span, :class => "machine-link") do
      link_to(machine.name, machine) + content_tag(:span, :class => "machine-details") do
        [ machine.operating_system,
          (machine.nb_proc > 0 ? machine.cores : ""),
          (machine.memory.present? ? "#{machine.ram}G" : ""),
          (machine.disk_size > 0 ? machine.disks : "") ].reject(&:blank?).join(" | ")
      end
    end
  end
end
