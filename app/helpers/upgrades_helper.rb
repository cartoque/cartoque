#encoding: utf-8

module UpgradesHelper
  def format_packages_list(packages_list)
    sort_order = {"needing_reboot"=>0, "important"=>1, "normal"=>2}
    packages_list.sort_by do |p|
      sort_order[p[:status]]
    end.map do |p|
      format_package_upgrade(p)
    end.join(" ").html_safe
  end

  def format_package_upgrade(package)
    content_tag :span, h(package[:name]), :class => "package package_#{package[:status]}",
                                          :title => "#{h package[:old]} → #{h package[:new]}".html_safe
  end

  def validated_by(upgrader)
    t(:validated_by, :person => upgrader.name)
  end
end
