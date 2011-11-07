module ToolsHelper
  def symetry_table_for(nodes, options = {}, &block)
    title = options[:title]
    status = options[:status]
    final = content_tag(:h2, :class => (status ? "identical" : "different")) do
      content_tag(:span, image_tag("bullet_toggle_plus.png", :size => "16x16", :class => "inline"), :class => "more") + title
    end
    final << content_tag(:table, :class => "list symetry", :style => "display:none;") do
      output = content_tag :tr do
        nodes.map{|node| %(<th style="width:#{td_size(node == nodes.first, nodes.size, options)}%;">#{node}</th>)}.join.html_safe
      end
      output.safe_concat(capture(&block)) if block_given?
      output
    end
    final
  end

  def td_size(first_node, nodes_count, options)
    if options[:diff] && !options[:status]
      if first_node
        20
      else
        80 / (nodes_count - 1)
      end
    else
      100 / nodes_count
    end
  end

  def render_diff_list(title, elements)
    buff = content_tag :ul do
      buff2 = content_tag(:li, "<strong>#{pluralize(elements.count, "serveur")} #{title}</strong>".html_safe)
      buff2 << content_tag(:ul, :class => "comparison details") do
        elements.sort.map{|m| "<li>#{m}</li>"}.join.html_safe
      end
      buff2
    end
    buff << content_tag(:div, "", :class => "clear")
  end
end
