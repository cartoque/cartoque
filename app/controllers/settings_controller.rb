#encoding: utf-8
class SettingsController < ApplicationController
  layout 'admin'

  def index
  end

  def update_all
    keys = Setting.fields.keys - %w(_id _type)
    attrs = params[:settings].select{|k,v| k.in?(keys)}
    if Setting.site_announcement_message != attrs["site_announcement_message"]
      attrs["site_announcement_updated_at"] = Time.now
    end
    if Setting.update_attributes(attrs)
      redirect_to settings_path, notice: t(:settings_updated)
    else
      render "index"
    end
  end
end
