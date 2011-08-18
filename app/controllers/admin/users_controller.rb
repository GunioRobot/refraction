class Admin::UsersController < ApplicationController
  before_filter :admin_needed
  
  def index
    @users=User.all.paginate :page=>params[:page],:per_page => 10
    @count=User.count
  end
  
  def show
    @user=User.find(params[:id])
    @tweets=@user.tweets.all.order_by([:created_at, :desc]).limit 10
    @comments=@user.comments.order_by([:created_at, :desc]).limit 10
    
  end

  def tweets
    @user=User.find(params[:id])
    @tweets=@user.tweets.all.order_by([:created_at, :desc]).paginate :page=>params[:page],:per_page => 10
  end

  def comments
    @user=User.find(params[:id])
    @comments=@user.comments.order_by([:created_at, :desc]).all.paginate :page=>params[:page],:per_page => 10

  end

  def addroles
    roles=params[:add_roles]
    @user=User.find(params[:id])
    @user.add_roles!(roles)
    respond_to do |format|
      format.html {redirect_to admin_user_url(@user)}
      format.js {render :layout=>false}
    end
    
  end

  def removeroles
    roles=params[:remove_roles]
    @user=User.find(params[:id])
    @user.remove_roles!(roles)
    respond_to do |format|
      format.html {redirect_to admin_user_url(@user)}
      format.js { render 'addroles', :layout=>false }
    end
  end

  def resetroles
    roles=params[:reset_roles]
    @user=User.find(params[:id])
    @user.reset_roles!(roles)
    respond_to do |format|
      format.html {redirect_to admin_user_url(@user)}
      format.js { render 'addroles', :layout=>false }
    end
  end

  def removerole
    role=params[:role]
    @user=User.find(params[:id])
    @user.remove_roles!(role)
    respond_to do |format|
      format.html {redirect_to admin_user_url(@user)}
      format.js {render 'addroles', :layout=>false }
    end
      
  end
  
  
end
