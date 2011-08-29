class Admin::UsersController < ApplicationController
  before_filter :admin_needed
  
  def index
    @users=User.desc(:created_at) 
    @count=User.count
  end
  
  def show
    @user=User.find(params[:id])
    @tweets=@user.tweets.all.order_by([:created_at, :desc]).limit 10
    @comments=@user.comments.order_by([:created_at, :desc]).limit 10
    
  end

  def tweets
    @user=User.find(params[:id])
    @tweets=@user.tweets.all.order_by([:created_at, :desc]) 
  end

  def comments
    @user=User.find(params[:id])
    @comments=@user.comments.order_by([:created_at, :desc]).all 

  end

  def addroles
    roles=params[:add_roles]
    @user=User.find(params[:id])
    @user.add_roles!(roles)
    Log.new(:from=>current_user,:action=>'added roles'+roles, :to=>@user).save
    respond_to do |format|
      format.html {redirect_to admin_user_url(@user)}
      format.js {render :layout=>false}
    end
    
  end

  def removeroles
    roles=params[:remove_roles]
    @user=User.find(params[:id])
    @user.remove_roles!(roles)
    Log.new(:from=>current_user,:action=>'removed roles'+roles, :to=>@user).save
    respond_to do |format|
      format.html {redirect_to admin_user_url(@user)}
      format.js { render 'addroles', :layout=>false }
    end
  end

  def resetroles
    roles=params[:reset_roles]
    @user=User.find(params[:id])
    @user.reset_roles!(roles)
    Log.new(:from=>current_user,:action=>'reset to roles '+roles, :to=>@user).save
    respond_to do |format|
      format.html {redirect_to admin_user_url(@user)}
      format.js { render 'addroles', :layout=>false }
    end
  end

  def removerole
    role=params[:role]
    @user=User.find(params[:id])
    @user.remove_roles!(role)
    Log.new(:from=>current_user,:action=>'removed role '+role, :to=>@user).save
    respond_to do |format|
      format.html {redirect_to admin_user_url(@user)}
      format.js {render 'addroles', :layout=>false }
    end
      
  end
  
  
end
