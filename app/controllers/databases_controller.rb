class DatabasesController < InheritedResources::Base
  before_filter :select_view_mode

  respond_to :html, :js

  has_scope :by_name
  has_scope :by_type

  def distribution
    if params[:format] == "json"
      @databases = Database.all
      map = {"oracle" => [], "postgres" => []}
      @databases.each do |database|
        dbtype = database.database_type
        dbmap = {"name" => database.name, "children" => []}
        database.report.each do |report|
          name = report["ora_instance"].presence || report["pg_cluster"]
          subdbs = report["schemas"].presence || report["databases"]
          if name.present? && subdbs.present?
            schemas = subdbs.map{|schema,size| {"name"=>schema, "size"=>size}}
            dbmap["children"] << {"name" => name, "children" => schemas}
          end
        end
        map[dbtype] << dbmap
      end
      @json = {"name"=>"databases", "children"=>[{"name" => "postgres", "children" => map["postgres"]}, {"name" => "oracle", "children" => map["oracle"]}]}
    end

    respond_to do |format|
      format.json { render :json => @json }
      format.html
    end
  end

  def create
    create! { databases_url }
  end

  def update
    update! { databases_url }
  end

  private

  def select_view_mode
    current_user.update_setting(:databases_view_mode, params[:view_mode]) if params[:view_mode]
  end

  def databases_view_mode
    if action_name == "show" || request_from_pdfkit?
      "detailed"
    else
      current_user.settings[:databases_view_mode] || "normal"
    end
  end
  helper_method :databases_view_mode
end
