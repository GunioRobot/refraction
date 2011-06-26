class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def set_page_title(title)
    @page_title=title
  end
  
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end
end
