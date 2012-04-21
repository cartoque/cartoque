# encoding: utf-8
module ServersHelper
  def render_maintainer(server, maintainer)
    return "" unless maintainer
    html =  "#{link_to maintainer, maintainer} "
    html << link_to_function(image_tag("info.gif", size: "12x12", class: "inline"),
                             %[$("#maintenance-#{server.id}").slideToggle(130); return false;],
                             class: "maintainer-infos hide-when-print")
    html << " "
    html << " - #{server.contract_type}" if server.contract_type?
    html << %(<ul style="display:none" class="maintainer" id="maintenance-#{server.id}">)
    html << %(<li>Téléphone: #{maintainer.phone}</li>)
    html << %(<li>Mail: #{mail_to maintainer.email}</li>)
    html << "</ul>"
    html.html_safe
  end

  def options_for_location_filter(selected)
    options = Site.all.inject([["",""]]) do |memo,site|
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
     content_tag(:span, t(type), class: "label") +
       content_tag(:div, render_link_collection(links, type), class: "content")
  end

  def render_link_collection(links, type)
    list = links.map do |link|
      h = %(<li class="link-#{link.link_type}">)
      h << %(<span class="server_label">)
      h << %(#{link.server_label || link.link_type})
      h << %(</span>)
      h << %( #{link_to(link.server.name, link.server)} ) if type == :connected_links
      h << %( <span class="link-arrow">&rarr;</span> )
      h << %( #{link_to(link.switch.name, link.switch)} ) if type == :physical_links
      h << %(<span class="switch_label">)
      h << %( #{link.switch_label})
      h << %(</span>)
      h << %(</li>)
      h
    end.join
    %(<ul class="collection">#{list}</ul>).html_safe
  end
end
