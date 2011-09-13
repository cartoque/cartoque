module ToolsHelper
  def symetry_table_for(nodes, options = {}, &block)
    title = options.delete(:title)
    status = options.delete(:status)
    final = content_tag(:h2, :class => (status ? "identical" : "different")) do
      content_tag(:span, image_tag("bullet_toggle_plus.png", :class => "inline"), :class => "more") + title
    end
    final << content_tag(:table, :class => "list symetry", :style => "display:none;") do
      output = content_tag :tr do
        nodes.map{|node| %(<th style="width:#{100 / nodes.size}%;">#{node}</th>)}.join.html_safe
      end
      output.safe_concat(capture(&block)) if block_given?
      output
    end
    final
  end
end
