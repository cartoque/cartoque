module TomcatsHelper
  def tomcat_vips(tomcats)
    @vips ||= tomcats.map(&:vip).compact
  end

  def tomcat_vips_if_any(tomcats)
    content_tag(:ul, class: 'tomcat_vips') do
      tomcat_vips(tomcats).sort.uniq.map do |vip|
        content_tag(:li, "via #{vip}")
      end.join("\n").html_safe
    end if tomcat_vips(tomcats).present?
  end

  def tomcat_links_to_servers(tomcats)
    tomcats.map do |tomcat|
      link_to_server_if_exists tomcat.server
    end.sort.uniq.join("<br/>").html_safe
  end

  def tomcat_names(tomcats)
    tomcats.map(&:name).map(&:to_s).sort.uniq.join("<br/>").html_safe
  end

  def tomcat_java_versions(tomcats)
    tomcats.map(&:java_version).map(&:to_s).sort.uniq.join("<br/>").html_safe
  end

  def tomcat_jvm_params(tomcats)
    @jvm_params = tomcats.map do |tomcat|
      if tomcat.java_xms.present? || tomcat.java_xmx.present?
        "#{tomcat.java_xms} / #{tomcat.java_xmx}"
      end
    end.compact.sort.uniq.join("<br/>").html_safe
  end

  def tomcat_jvm_params_if_any(tomcats)
    content_tag(:p, class: 'details') do
      tomcat_jvm_params(tomcats)
    end if tomcat_jvm_params(tomcats).present?
  end

  def tomcat_cerbere(tomcat)
    if tomcat.cerbere
      image_tag("lock.png", size: "16x16") \
        + tag(:br) \
        + content_tag(:span, 'csac', class: (tomcat.cerbere_csac ? 'csacok' : 'csacko'))
    end
  end

  def tomcat_datasource(tomcat)
    html = ""
    if tomcat.jdbc_url
      html << tomcat.jdbc_server
      if tomcat.jdbc_db
        html << tag(:br)
        html << "#{tomcat.jdbc_user} @ #{tomcat.jdbc_db}"
      end
    end
    html.html_safe
  end
end
