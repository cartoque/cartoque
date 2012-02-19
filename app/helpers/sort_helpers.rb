module SortHelpers
  private

  # Mongoid
  def mongo_sort_option
    sort_column.split(",").map do |column|
      full_column_name = (column.include?(".") ? column : sort_column_prefix+column)
      [full_column_name, sort_direction]
    end
  end

  # ActiveRecord
  def sort_option
    sort_column.split(",").map do |column|
      full_column_name = (column.include?(".") ? column : sort_column_prefix+column)
      "#{full_column_name} #{sort_direction}"
    end.join(", ")
  end

  def sort_column
    columns = "#{params[:sort]}".split(",").select do |column|
      resource = resource_class
      if column.include?(".")
        resource_name, column = column.split(".")
        resource = resource_name.classify.constantize rescue resource
      end
      column.in?(available_fields)
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

  def available_fields
    #differentiate mongoid and active_record models
    resource_class.respond_to?(:column_names) ? resource_class.column_names : resource_class.fields.keys
  end
end
