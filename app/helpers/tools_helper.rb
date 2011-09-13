module ToolsHelper
  def symetry_table_for(nodes, options = {}, &block)
    content_tag :table, :class => "list symetry" do
      output = content_tag :tr do
        (%(<th style="width:10%;">) + nodes.map{|node| %(<th style="width:#{90 / nodes.size}%;">#{node}</th>)}.join).html_safe
      end
      output.safe_concat(capture(&block))
      output
    end
  end
end
