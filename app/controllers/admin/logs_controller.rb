class Admin::LogsController < ApplicationController
  before_filter :admin_needed
  
  def index
    @logs=Log.all
  end
  
end
