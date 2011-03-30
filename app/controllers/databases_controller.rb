class DatabasesController < InheritedResources::Base
  def create
    create! { databases_url }
  end

  def update
    update! { databases_url }
  end
end
