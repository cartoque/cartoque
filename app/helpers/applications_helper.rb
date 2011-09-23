module ApplicationsHelper
  def collection_for_authentication_methods
    ApplicationInstance::AVAILABLE_AUTHENTICATION_METHODS.map do |meth|
      [ t("authentication.#{meth}"), meth ]
    end
  end

  def link_to_doc(doc)
    site = "http://dokuwiki.application.ac.centre-serveur.i2"
    link_to doc.gsub("documentation_generale:",""), "#{site}/doku.php?id=#{doc}", :class => "icon icon-url"
  end
end
