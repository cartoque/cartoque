module OperatingSystemsHelper
  def render_operating_system(operating_system)
    img = ""
    icon_path = operating_system.icon_path.gsub("images/","")
    if File.file?(Rails.root.join("public","images",icon_path))
      img << image_tag(icon_path, :size => "12x12", :class => "os-icon")
    else
      img << image_tag("blank.gif", :size => "12x12", :class => "os-icon")
    end
    img.html_safe + operating_system.nom
  end

  def nested_operating_systems(operating_systems)
    operating_systems.map do |operating_system, sub_os|
      render(operating_system) + content_tag(:div, nested_operating_systems(sub_os), :class => "nested-os")
    end.join.html_safe
  end
end
