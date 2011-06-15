class StoragesController < InheritedResources::Base
  respond_to :html, :js, :xml

  has_scope :by_constructor

  def create
    create! { storages_url }
  end

  def update
    update! { storages_url }
  end
end
