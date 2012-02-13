module LicensesHelper
  def renewal_limit(date)
    return "" if date.blank?
    days_before_end = date - Date.today
    if days_before_end <= 15
      content_tag(:span, l(date), class: "renewal-critical")
    elsif days_before_end <= 3*30
      content_tag(:span, l(date), class: "renewal-warning")
    else
      l(date)
    end
  end
end
