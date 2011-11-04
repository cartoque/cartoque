module LicensesHelper
  def renewal_limit(date)
    return "" if date.blank?
    months_before_end = ((date - Date.today) / 30).to_f
    if months_before_end <= 6
      content_tag(:span, l(date), :class => "renewal-critical")
    elsif months_before_end <= 12
      content_tag(:span, l(date), :class => "renewal-warning")
    else
      l(date)
    end
  end
end
