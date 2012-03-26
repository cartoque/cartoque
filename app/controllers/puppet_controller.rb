class PuppetController < ApplicationController
  respond_to :html, :js

  has_scope :by_puppet
  has_scope :by_virtual
  has_scope :by_system
  has_scope :by_osrelease
  has_scope :by_puppetversion
  has_scope :by_facterversion
  has_scope :by_rubyversion

  def servers
    @servers = apply_scopes(MongoServer).active.real_servers.like(params[:search]).order_by(mongo_sort_option)
    for column in %w(puppetversion facterversion rubyversion operatingsystemrelease) do
      instance_variable_set("@#{column}s", MongoServer.all.distinct(column).sort)
    end
    @to_puppetize = MongoServer.where(operating_system_id: OperatingSystem.where(managed_with_puppet: true))
                               .where(puppetversion: nil)
                               .order_by([:name.asc])
    @puppetized_count = MongoServer.by_puppet(1).count
  end

  def classes
  end

  include SortHelpers
  helper_method :sort_column, :sort_direction, :sort_column_prefix

  protected
  def resource_class
    MongoServer
  end
end
