# encoding: utf-8
module MachinesHelper
  def maintenance_limit(date)
    return content_tag(:span, "non", :class => "maintenance-critical") if date.blank?
    months_before_end = ((date - Date.today) / 30).to_f
    if months_before_end <= 6
      content_tag(:span, l(date), :class => "maintenance-critical")
    elsif months_before_end <= 12
      content_tag(:span, l(date), :class => "maintenance-warning")
    else
      l(date)
    end
  end

  def render_mainteneur(machine)
    return "" unless machine.mainteneur
    html =  "#{link_to machine.mainteneur, machine.mainteneur} "
    html << link_to_function("[infos]", %[$("#maintenance-#{machine.id}").slideToggle(130); return false;],
                             :class => "mainteneur-infos hide-when-print")
    html << " "
    html << " - #{machine.contract_type}" if machine.contract_type?
    html << %(<ul style="display:none" class="machine-mainteneur" id="maintenance-#{machine.id}">)
    html << %(<li>Référence client: #{machine.mainteneur.client_ref}</li>)
    html << %(<li>Téléphone: #{machine.mainteneur.phone}</li>)
    html << %(<li>Mail: #{mail_to machine.mainteneur.email}</li>)
    html << %(<li>Adresse: #{machine.mainteneur.address}</li>)
    html << "</ul>"
    html.html_safe
  end
end
