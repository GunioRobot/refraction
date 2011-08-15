class Admin::DashboardController < ApplicationController
  before_filter :admin_needed
  
  def show
    @tweet_count=Tweet.count
    @comment_count=Comment.count
    @user_count=User.count
    
    
  end
end
