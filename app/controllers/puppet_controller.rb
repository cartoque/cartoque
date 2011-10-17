class PuppetController < ApplicationController
  respond_to :html, :js

  has_scope :by_puppet
  has_scope :by_virtual
  has_scope :by_system

  def servers
    @servers = apply_scopes(Server).search(params[:search]).order(sort_option)
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
