class LicensesController < InheritedResources::Base
  respond_to :html, :js
  actions :index

  has_scope :by_editor
  has_scope :by_key
  has_scope :by_title
  has_scope :by_server

  before_filter :find_filter_keys, :only => :index

  private
  def find_filter_keys
    @editors = License.select("distinct(editor)").map(&:editor).sort
    @servers = Server.where(:id => License.joins(:servers).select("distinct(servers.id)").map(&:id)).sort_by(&:name)
  end
end
