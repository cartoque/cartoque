module MachinesHelper
  def maintenance_limit(date)
    return "" unless date
    months_before_end = ((date - Date.today) / 30).to_f
    if months_before_end <= 6
      content_tag(:span, l(date), :class => "maintenance-critical")
    elsif months_before_end <= 12
      content_tag(:span, l(date), :class => "maintenance-warning")
    else
      l(date)
    end
  end
end
