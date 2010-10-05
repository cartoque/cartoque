module ApplicationsHelper
  def cerbere_image(has_cerbere)
    #TODO: migrate application.cerbere to a boolean!
    image_tag("cerbere.gif") if has_cerbere == 1
  end
end
