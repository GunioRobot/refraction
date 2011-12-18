class Admin::DashboardController < ApplicationController
  before_filter :admin_needed

  def show
    @tweet_count=Tweet.count
    @comment_count=Comment.count
    @user_count=User.count

    @today_tweet_count = Tweet.count :conditions => {:created_at.gt => Date.today.to_time}
    @today_comment_count = Comment.count :conditions => {:created_at.gt => Date.today.to_time}
    @today_user_count = User.count :conditions => {:created_at.gt => Date.today.to_time}


  end
end
