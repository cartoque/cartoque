class ContactDecorator < ResourceDecorator
  decorates :contact

  include ContactableDecorations
end
