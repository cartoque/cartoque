#encoding: utf-8
class SettingsController < ApplicationController
  layout 'admin'

  def index
  end

  def update_all
    settings = Settler.load!.inject({}){|memo,s| memo[s.key] = s; memo}
    params[:settings].each do |key,value|
      if settings[key].value != value
        settings[key].value = value
        settings[key].save
      end
    end
    redirect_to settings_path, notice: "Paramètres mis à jour"
  end
end
