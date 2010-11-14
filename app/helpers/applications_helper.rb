module ApplicationsHelper
  def cerbere_image(has_cerbere, ifnot = false)
    if has_cerbere
      image_tag("cerbere.gif")
    elsif ifnot
      image_tag("false_cerbere.gif")
    end
  end
end
