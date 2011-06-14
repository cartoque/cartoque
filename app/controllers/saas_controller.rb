class SaasController < ApplicationController
  def index
    @redmine_instances = RedmineInstance.all.sort_by{|i| [i.server, i.name]}
  end

  def show
  end

end
