module UpgradesHelper
  def format_packages_list(packages_list)
    sort_order = {"needing_reboot"=>0, "important"=>1, "normal"=>2}
    packages_list.sort_by do |p|
      sort_order[p[:status]]
    end.map do |p|
      content_tag(:span, h(p[:name]), :class => "package_#{p[:status]}")
    end.join(" ").html_safe
  end
end
