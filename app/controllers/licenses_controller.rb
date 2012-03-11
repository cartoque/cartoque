class LicensesController < InheritedResources::Base
  respond_to :html, :js
  actions :index, :create, :edit, :update, :destroy

  has_scope :by_editor
  has_scope :by_key
  has_scope :by_title
  has_scope :by_server

  before_filter :find_filter_keys, only: :index

  private
  def find_filter_keys
    @editors = License.all.map(&:editor).uniq.sort
    @servers = Server.where(id: ActiveRecord::Base.connection.execute("SELECT distinct(server_id) FROM licenses_servers;").to_a.flatten)
                     .sort_by(&:name)
  end
end
