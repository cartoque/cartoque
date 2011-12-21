# Abstract controller for managing in one single point our InheritedResources controllers
# See: https://github.com/jcasimir/draper/issues/99 for more details
class ResourcesController < InheritedResources::Base
  include ActiveSupport::Inflector

  protected

  def collection
    get_resource_ivar || set_resource_ivar(decorate_resource_or_collection(end_of_association_chain))
  end

  def resource
    get_resource_ivar || set_resource_ivar(decorate_resource_or_collection(super))
  end

  private

  def decorate_resource_or_collection(item_or_items)
    constantize(resource_class.name + "Decorator").decorate(item_or_items)
  rescue NameError
    item_or_items
  end
end
