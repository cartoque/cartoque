module DatabasesHelper
  include SizeHelper

  def databases_summary(databases)
    return "" if databases.blank?
    total_size = databases.values.sum
    top_databases = databases.select do |db,size|
      size >= total_size / 6
    end.keys
    if top_databases.size == 0
      top_databases = databases.sort_by do |db,size|
        size
      end.reverse.map do |a|
        a[0]
      end.first(2)
    end
    html = %(#{top_databases.join(", ")})
    html << %(,&nbsp;...) if top_databases.size < databases.size
    html << %(<span style="float:right; padding-left:1em">#{display_size(total_size)}</span>)
    html.html_safe
  end
end
