class ServerDecorator < ResourceDecorator
  decorates :server

  def virtual_badge
    blank_unless model.virtual? do
      h.content_tag(:div, "V", class: "contextual item-badge virtual-server")
    end
  end

  def puppet_badge
    blank_unless model.puppetversion.present? do
      h.content_tag(:div, "P", class: "contextual item-badge has-puppet")
    end
  end

  def network_device_badge
    blank_unless model.network_device? do
      h.content_tag(:div, h.image_tag("router.png", title: t(:network_device), size: "16x16"),
                    class: "contextual item-badge network-device")
    end
  end

  def badges
    virtual_badge + puppet_badge + network_device_badge
  end

  def blank_unless(condition)
    (condition ? yield : "").html_safe
  end

  def cores
    html = ""
    html << "#{model.processor_physical_count} * " unless model.processor_physical_count == 1
    html << "#{model.processor_cores_per_cpu} cores, " unless model.processor_cores_per_cpu.blank? || model.processor_cores_per_cpu <= 1
    html << "#{model.processor_frequency_GHz} GHz" unless model.processor_frequency_GHz == 0
    html.html_safe
  end

  def cpu
    html = ""
    if model.known_processor?
      html << cores
      html << h.content_tag(:span, model.processor_reference, class: "processor-reference") if model.processor_reference.present?
    else
      html << "?"
    end
    html.html_safe
  end

  def disks
    html = ""
    if model.disk_size.present? && model.disk_size > 0
      html << "#{model.nb_disk} * " unless model.nb_disk.blank? || model.nb_disk == 1
      html << "#{model.disk_size}G"
      html << " (#{model.disk_type})" unless model.disk_type.blank?
      if model.disk_size_alt.present? && model.disk_size_alt > 0
        html << "<br />"
        html << "#{model.nb_disk_alt} * " unless model.nb_disk_alt.blank? || model.nb_disk_alt == 1
        html << "#{model.disk_size_alt}G"
        html << " (#{model.disk_type_alt})" unless model.disk_type_alt.blank?
      end
    else
      html << "?"
    end
    html.html_safe
  end

  def memory
    html = ""
    if model.known_memory?
      memory_num, memory_unit = ( model.memory_GB.to_f > 1 ?  [model.memory_GB, "GB"] : [model.memory_MB, "MB"] )
      html = memory_num.to_s.gsub(/\.0*$/,'') + memory_unit
    else
      html << "?"
    end
    html
  end

  def short_line
    h.content_tag(:span, class: "server-link") do
      h.link_to(model.name, model) + h.content_tag(:span, class: "server-summary") do
        [ model.operating_system_name,
          (model.processor_physical_count && model.processor_physical_count > 0 ? cores : ""),
          (model.memory_MB.present? ? memory : ""),
          (model.disk_size && model.disk_size > 0 ? disks : "") ].reject(&:blank?).join(" | ")
      end
    end
  end

  def maintenance_limit
    date = model.maintained_until
    return h.content_tag(:span, t(:word_no), class: "maintenance-critical") if date.blank?
    months_before_end = ((date - Date.today) / 30).to_f
    if months_before_end <= 6
      h.content_tag(:span, l(date), class: "maintenance-critical")
    elsif months_before_end <= 12
      h.content_tag(:span, l(date), class: "maintenance-warning")
    else
      l(date)
    end
  end

  def title
    if model.virtual? || model.fullmodel.present?
      h.content_tag :h2 do
        if model.virtual?
          t(:virtual_machine)
        else
          model.fullmodel
        end
      end
    end
  end

  def location
    if model.physical_rack.present? || model.hypervisor
      h.content_tag :div, class: "server-location" do
        h.content_tag(:i, '', class: "icon-map-marker") +
          if model.virtual?
            h.link_to model.hypervisor, model.hypervisor
          else
            h.link_to(model.physical_rack, h.servers_path(by_location: "rack-#{model.physical_rack.id}"))
          end
      end
    end
  end

  def system
    if model.operating_system.present?
      h.content_tag :div, class: 'server-system' do
        h.content_tag(:i, '', class: 'icon-cog') +
          model.operating_system +
          (model.arch.present? ? h.content_tag(:span, model.arch, class: 'server-arch') : '')
      end
    end
  end

  def maintenance_contract
    if [model.contract_type, model.delivered_on, model.maintained_until].compact.any?
      html = "#{model.contract_type.presence || "?"}"
      if model.delivered_on.present? || model.maintained_until.present?
        html << "<br>#{model.delivered_on} &rarr; #{model.maintained_until}"
      end
      html.html_safe
    else
      "?"
    end
  end

  def serial_numbers
    ary = []
    ary << model.serial_number if model.serial_number.present?
    ary += model.server_extensions.map do |extension|
      "#{extension.serial_number} (#{extension.name})" if extension.serial_number.present?
    end.compact
    ary
  end

  def serial_numbers_list
    serial_numbers.map do |sn|
      a = ERB::Util.html_escape(sn)
      a = h.content_tag(:span, a, class: 'tiny') if sn.include?("(")
      a
    end.join("<br />").html_safe
  end

  # Accessing Helpers
  #   You can access any helper via a proxy
  #
  #   Normal Usage: helpers.number_to_currency(2)
  #   Abbreviated : h.number_to_currency(2)
  #   
  #   Or, optionally enable "lazy helpers" by calling this method:
  #     lazy_helpers
  #   Then use the helpers with no proxy:
  #     number_to_currency(2)

  # Defining an Interface
  #   Control access to the wrapped subject's methods using one of the following:
  #
  #   To allow only the listed methods (whitelist):
  #     allows :method1, :method2
  #
  #   To allow everything except the listed methods (blacklist):
  #     denies :method1, :method2

  # Presentation Methods
  #   Define your own instance methods, even overriding accessors
  #   generated by ActiveRecord:
  #   
  #   def created_at
  #     h.content_tag :span, time.strftime("%a %m/%d/%y"), 
  #                   class: 'timestamp'
  #   end
end
