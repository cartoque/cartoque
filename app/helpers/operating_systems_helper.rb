module OperatingSystemsHelper
  def render_operating_system(operating_system)
    img = ""
    icon_path = operating_system.icon_path.gsub("images/","")
    if File.file?(Rails.root.join("public","images",icon_path))
      img << image_tag(icon_path, size: "12x12", class: "os-icon")
    else
      img << image_tag("blank.gif", size: "12x12", class: "os-icon")
    end
    img.html_safe + operating_system.name
  end

  def nested_operating_systems(operating_systems)
    operating_systems.map do |operating_system, sub_os|
      subtree_ids = [operating_system.id] + descendant_ids(sub_os)
      render(operating_system, subtree: subtree_ids) + nested_operating_systems(sub_os)
    end.join.html_safe
  end

  def descendant_ids(sub_os)
    sub_os.inject([]) do |memo,subset|
      memo << subset.first.id #key os
      memo += descendant_ids(subset.last) #children
      memo
    end
  end
end
