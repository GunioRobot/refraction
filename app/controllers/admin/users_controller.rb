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
  
  
end
