class UsersController < ApplicationController
  def show
    @user=User.find(params[:id])

    respond_to do |format|
      format.xml {render :xml=>@user}
    end
  end
end
