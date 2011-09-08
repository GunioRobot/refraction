class Admin::CirclesController < ApplicationController
  before_filter :admin_needed
  
  def index
    @circles=Circle.all
    
  end
  
  def show
    circle=Circle.find(params[:id])
    @sites=circle.sites
  end
  
end
