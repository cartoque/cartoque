class BackupJobsController < InheritedResources::Base
  respond_to :html, :js
  actions :index
end
