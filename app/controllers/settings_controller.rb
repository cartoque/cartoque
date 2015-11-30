#encoding: utf-8
class SettingsController < ApplicationController
  layout 'admin'

  respond_to :json, only: [:index]

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

  def edit_visibility
    respond_to do |format|
      format.js
    end
  end

  def update_visibility
    ids = params[:visible_datacenter_ids] || []
    if current_user.update_attributes(visible_datacenter_ids: ids)
      redirect_to params[:back_url], notice: t(:settings_updated)
    else
      redirect_to params[:back_url], error: t(:unknown_error)
    end
  end
end
