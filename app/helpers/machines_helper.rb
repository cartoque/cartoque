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
    html = "#{machine.mainteneur} "
    html << link_to_function("[infos]", %[$("#maintenance-#{machine.id}").slideToggle(130); return false;],
                             :class => "mainteneur-infos hide-when-print")
    html << " "
    html << " - #{machine.type_contrat}" if machine.type_contrat.present?
    html << %(<ul style="display:none" class="machine-mainteneur" id="maintenance-#{machine.id}">)
    html << %(<li>Référence client: #{machine.mainteneur.ref_client}</li>)
    html << %(<li>Téléphone: #{machine.mainteneur.telephone}</li>)
    html << %(<li>Mail: #{mail_to machine.mainteneur.mail}</li>)
    html << %(<li>Adresse: #{machine.mainteneur.adresse}</li>)
    html << "</ul>"
    html.html_safe
  end
end
