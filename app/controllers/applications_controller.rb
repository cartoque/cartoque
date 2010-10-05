class ApplicationsController < ApplicationController
  def index
    @applications = Application.all
  end
  
  def show
    @application = Application.find(params[:id])
  end
  
  def new
    @application = Application.new
  end
  
  def create
    @application = Application.new(params[:application])
    if @application.save
      flash[:notice] = "Successfully created application."
      redirect_to @application
    else
      render :action => 'new'
    end
  end
  
  def edit
    @application = Application.find(params[:id])
  end
  
  def update
    @application = Application.find(params[:id])
    if @application.update_attributes(params[:application])
      flash[:notice] = "Successfully updated application."
      redirect_to @application
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @application = Application.find(params[:id])
    @application.destroy
    flash[:notice] = "Successfully destroyed application."
    redirect_to applications_url
  end
end
