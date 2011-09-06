# encoding: utf-8
module ServersHelper
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

  def render_mainteneur(server, mainteneur)
    return "" unless mainteneur
    html =  "#{link_to mainteneur, mainteneur} "
    html << link_to_function(image_tag("info.gif", :class => "inline"),
                             %[$("#maintenance-#{server.id}").slideToggle(130); return false;],
                             :class => "mainteneur-infos hide-when-print")
    html << " "
    html << " - #{server.contract_type}" if server.contract_type?
    html << %(<ul style="display:none" class="mainteneur" id="maintenance-#{server.id}">)
    html << %(<li>Référence client: #{mainteneur.client_ref}</li>)
    html << %(<li>Téléphone: #{mainteneur.phone}</li>)
    html << %(<li>Mail: #{mail_to mainteneur.email}</li>)
    html << %(<li>Adresse: #{mainteneur.address}</li>)
    html << "</ul>"
    html.html_safe
  end

  def options_for_location_filter(selected)
    options = Site.includes("physical_racks").inject([["",""]]) do |memo,site|
      memo << [site.name,"site-#{site.id}"]
      memo += site.physical_racks.map do |rack|
        ["&nbsp; #{rack}".html_safe, "rack-#{rack.id}"]
      end
      memo
    end
    options_for_select(options, selected).html_safe
  end

  def render_physical_links_association(server)
    render_links(server.physical_links.sort_by(&:server_label), :physical_links)
  end

  def render_connected_links_association(switch)
    render_links(switch.connected_links.sort_by(&:switch_label), :connected_links)
  end

  def render_links(links, type = :physical_links)
    content_tag :tr, :class => "wrapper server_#{type}" do
      content_tag(:td, t(type), :class => "label").safe_concat(
        content_tag(:td, render_link_collection(links, type), :class => "content")
      )
    end
  end

  def render_link_collection(links, type)
    list = links.map do |link|
      h = %(<li>)
      h << %(<span class="link-#{link.link_type}">)
      h << %(#{link.server_label || link.link_type})
      h << %(</span>)
      h << %( #{link_to(link.server.name, link.server)} ) if type == :connected_links
      h << %( &rarr; )
      h << %( #{link_to(link.switch.name, link.switch)} ) if type == :physical_links
      h << %( #{link.switch_label})
      h << %(</li>)
      h
    end.join
    %(<ul class="collection">#{list}</ul>).html_safe
  end
end
