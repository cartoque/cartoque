module SortHelpers
  private

  def sort_option
    sort_column.split(",").map do |column|
      "#{sort_column_prefix}#{column} #{sort_direction}"
    end.join(", ")
  end

  def sort_column
    columns = "#{params[:sort]}".split(",").select do |column|
      column.in? resource_class.column_names
    end
    columns << "name" if columns.blank?
    columns.join(",")
  end

  def sort_column_prefix
    ""
  end

  def sort_direction
    params[:direction].in?(%w(asc desc)) ? params[:direction] : "asc"
  end
end
