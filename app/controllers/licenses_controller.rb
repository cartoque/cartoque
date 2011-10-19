class LicensesController < InheritedResources::Base
  respond_to :html, :js
  actions :index
end
