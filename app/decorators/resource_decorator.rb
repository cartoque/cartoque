# Common pattern for decorating resources managed with InheritedResources
# See: https://github.com/jcasimir/draper/issues/99 for more details
class ResourceDecorator < ApplicationDecorator
  #TODO: understand why this method isn't passed to model
  def destroy
    model.destroy
  end

  #TODO: understand why this method isn't passed to model
  # -> occurred in "POST /servers"
  def update_attributes(*args)
    model.update_attributes(*args)
  end

  #TODO: understand why this method isn't passed to model
  # -> occurred when displaying crontasks in a modal box
  def to_s
    model.to_s
  end
end
