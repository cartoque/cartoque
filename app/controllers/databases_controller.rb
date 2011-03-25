class DatabasesController < ApplicationController
  def index
    @databases = Database.all
  end
  
  def show
    @database = Database.find(params[:id])
  end
  
  def new
    @database = Database.new
  end
  
  def create
    @database = Database.new(params[:database])
    if @database.save
      flash[:notice] = "Successfully created database."
      redirect_to @database
    else
      render :action => 'new'
    end
  end
  
  def edit
    @database = Database.find(params[:id])
  end
  
  def update
    @database = Database.find(params[:id])
    if @database.update_attributes(params[:database])
      flash[:notice] = "Successfully updated database."
      redirect_to @database
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @database = Database.find(params[:id])
    @database.destroy
    flash[:notice] = "Successfully destroyed database."
    redirect_to databases_url
  end
end
