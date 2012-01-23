class ContactDecorator < ResourceDecorator
  decorates :contact

  def long_form
    html = "".html_safe
    html << model.last_name
    html << ", #{model.first_name}" if model.first_name.present?
    html << " (#{model.company})" if model.company.present?
    html
  end

  def mailing_list_form
    html = long_form
    html << " <#{model.email_infos.first}>"
    html
  end
end
