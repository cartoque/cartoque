class ThemesController < InheritedResources::Base
  layout "admin"

  def create
    create! { themes_url }
  end

  def update
    update! { themes_url }
  end
end
