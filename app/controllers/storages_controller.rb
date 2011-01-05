class StoragesController < InheritedResources::Base
  def create
    create! { storages_url }
  end

  def update
    update! { storages_url }
  end
end
