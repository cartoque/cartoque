class ServicesController < InheritedResources::Base
  layout "admin"

  def create
    create! { services_url }
  end

  def update
    update! { services_url }
  end
end
