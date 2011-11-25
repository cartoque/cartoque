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
    @servers = apply_scopes(Server).active.real_servers.search(params[:search]).order(sort_option)
    for column in %w(puppetversion facterversion rubyversion operatingsystemrelease) do
      instance_variable_set("@#{column}s",
                            Server.select("distinct(#{column})").map(&:"#{column}").map(&:to_s).sort)
    end
    @to_puppetize = Server.where(:operating_system_id => OperatingSystem.where(:managed_with_puppet => true))
                          .where(:puppetversion => nil)
                          .order("name asc")
    @puppetized_count = Server.by_puppet(1).count
  end

  def classes
  end

  include SortHelpers

  protected

  def sort_column_prefix
    "servers."
  end
  helper_method :sort_column, :sort_direction, :sort_column_prefix

  def resource_class
    Server
  end
end
