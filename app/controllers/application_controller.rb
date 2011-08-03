class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def set_page_title(title)
    @page_title=title
  end
  
  def render_404
    render_optional_error_file(404)
  end
  
  def render_403
    render_optional_error_file(403)
  end
  
  def render_optional_error_file(status_code)
    status = status_code.to_s
    if ["404", "403", "500"].include?(status)
      render :template => "/errors/#{status}.html.erb", :status => status, :layout => "application"
    else
      render :template => "/errors/unknown.html.erb", :status => status, :layout => "application"
    end
  end

  def login_as(user)
    self.current_user = user
  end
  
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end
end
