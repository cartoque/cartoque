module ApplicationsHelper
  def cerbere_image(has_cerbere, ifnot = false)
    #TODO: migrate application.cerbere to a boolean!
    if has_cerbere == 1
      image_tag("cerbere.gif")
    elsif ifnot
      image_tag("false_cerbere.gif")
    end
  end
end
