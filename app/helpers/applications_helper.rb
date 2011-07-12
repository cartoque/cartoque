module ApplicationsHelper
  def cerbere_image(has_cerbere, ifnot = false)
    if has_cerbere
      image_tag("login.png")
    elsif ifnot
      image_tag("blank.gif")
    end
  end

  def collection_for_authentication_methods
    ApplicationInstance::AVAILABLE_AUTHENTICATION_METHODS.map do |meth|
      [ t("authentication.#{meth}"), meth ]
    end
  end
end
