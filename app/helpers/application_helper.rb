module ApplicationHelper
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
    pcts = [pcts, pcts] unless pcts.is_a?(Array)
    pcts = pcts.collect(&:round)
    pcts[1] = pcts[1] - pcts[0]
    pcts << (100 - pcts[1] - pcts[0])
    width = options[:width] || '120px;'
    legend = options[:legend] || ''
    o = %(<table class="progress" style="width:#{width};"><tr>)
    o << %(<td class="closed" style="width:#{pcts[0]}%;"></td>) if pcts[0] > 0
    o << %(<td class="done" style="width:#{pcts[1]}%;"></td>) if pcts[1] > 0
    o << %(<td class="todo" style="width:#{pcts[2]}%;"></td>) if pcts[2] > 0
    o << %(<td class="legend">#{legend}</td>)
    o << %(</tr></table>)
    o.html_safe
  end

  def show_version
    "<i>Cartoque v#{Cartocs::VERSION}</i>".html_safe
  end
end
