class PostitsController < ApplicationController
  respond_to :js

  before_filter :find_commentable

  def new
    @postit = @commentable.build_postit
  end

  def create
    if @commentable.create_postit(params[:postit])
      redirect_to params[:back_url]
    end
  end

  def edit
    @postit = @commentable.postit
  end

  def update
    if @commentable.postit.update_attributes(params[:postit])
      redirect_to params[:back_url]
    end
  end

  def destroy
    @commentable.postit.destroy
    redirect_to params[:back_url] and return
  end

  protected
  def find_commentable
    if params[:commentable_type] && params[:commentable_id]
      begin
        @commentable = params[:commentable_type].classify.constantize.find(params[:commentable_id])
      rescue
        #if anything fails above, then render a 404
        render_404 and return
      end
    end
    render_404 if @commentable.blank?
  end
end
