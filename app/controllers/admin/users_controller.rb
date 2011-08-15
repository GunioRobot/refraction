class Admin::UsersController < ApplicationController
  before_filter :admin_needed
  
  def index
    @users=User.all.paginate :page=>params[:page],:per_page => 10
    @count=User.count
  end
  
  def show
    @user=User.find(params[:id])
    @tweets=@user.tweets.all.limit 10
    @comments=@user.comments.limit 10
    
  end

  def tweets
    @user=User.find(params[:id])
    @tweets=@user.tweets.all.paginate :page=>params[:page],:per_page => 10
  end

  def comments
    @user=User.find(params[:id])
    @comments=@user.comments.all.paginate :page=>params[:page],:per_page => 10

  end
  
  
end
