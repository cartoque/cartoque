class ApplicationDecorator < ResourceDecorator
  decorates :application

  def title
    h.content_tag :h2, model.name
  end
end
