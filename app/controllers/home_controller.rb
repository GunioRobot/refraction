class HomeController < ApplicationController
  def index
    @user=current_user if current_user
      
  end
  def test
    authorize! :read, User, :message => "Unable to read this article."
  end
end
