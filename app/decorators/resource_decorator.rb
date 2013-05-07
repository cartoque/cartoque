# Common pattern for decorating resources managed with InheritedResources
# See: https://github.com/jcasimir/draper/issues/99 for more details
class ResourceDecorator < Draper::Decorator
  delegate_all

  # Lazy Helpers
  #   PRO: Call Rails helpers without the h. proxy
  #        example: number_to_currency(model.price)
  #   CON: Add a bazillion methods into your decorator's namespace
  #        and probably sacrifice performance/memory
  #  
  #   Enable them by uncommenting this line:
  #   lazy_helpers

  # Shared Decorations
  #   Consider defining shared methods common to all your models.
  #   
  #   Example: standardize the formatting of timestamps
  #
  #   def formatted_timestamp(time)
  #     h.content_tag :span, time.strftime("%a %m/%d/%y"), 
  #                   class: 'timestamp' 
  #   end
  # 
  #   def created_at
  #     formatted_timestamp(model.created_at)
  #   end
  # 
  #   def updated_at
  #     formatted_timestamp(model.updated_at)
  #   end
  def t(*args)
    I18n.t(*args)
  end

  def l(*args)
    I18n.l(*args)
  end

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
  
  #Common to servers and applications
  def description_if_present
    if model.description.present?
      h.content_tag :div, class: 'description' do
        model.description
      end
    end
  end
end
