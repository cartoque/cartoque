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
    @servers = MongoServer.where(:_id.in => License.all.distinct(:server_ids).flatten.uniq).order_by(:name.asc)
  end
end
