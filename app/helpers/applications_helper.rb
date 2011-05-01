module ApplicationsHelper
  def cerbere_image(has_cerbere, ifnot = false)
    if has_cerbere
      image_tag("login.png")
    elsif ifnot
      image_tag("blank.gif")
    end
  end
end
