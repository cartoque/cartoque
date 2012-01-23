class ContactDecorator < ResourceDecorator
  decorates :contact

  def short_form
    html = "".html_safe
    html << model.last_name
    html << ", #{model.first_name}" if model.first_name.present?
    html
  end

  def long_form
    html = short_form
    html << " (#{model.company})" if model.company.present?
    html
  end

  def mailing_list_form
    html = long_form
    html << " <#{model.email_infos.first}>"
    html
  end

  def to_html(form = :short_form)
    h.link_to send(form), model
  end
end
