class CompanyDecorator < ResourceDecorator
  decorates :company

  include ContactableDecorations
end
