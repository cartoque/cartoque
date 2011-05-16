module SortHelpers
  private

  def sort_option
    sort_column.split(",").map do |column|
      column + " " + sort_direction
    end.join(", ")
  end

  def sort_column
    columns = "#{params[:sort]}".split(",").select do |column|
      resource_class.column_names.include?(column)
    end
    columns << "name" if columns.blank?
    columns.join(",")
  end

  def sort_direction
    %w(asc desc).include?(params[:direction]) ? params[:direction] : "asc"
  end
end
