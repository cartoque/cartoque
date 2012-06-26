require 'csv'

class TomcatsController < ResourcesController
  respond_to :html, :js, :csv
  respond_to :json, only: [:index, :show]

  has_scope :by_name
  has_scope :by_dns
  has_scope :by_java_version
  has_scope :by_server_name

  def collection
    @tomcats ||= end_of_association_chain.order_by(:name.asc)
  end
end
