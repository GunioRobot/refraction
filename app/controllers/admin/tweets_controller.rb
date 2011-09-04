class Admin::TweetsController < ApplicationController
  before_filter :admin_needed

  def index
    @tweets=Tweet.all.order_by([:created_at, :desc]) 
    @count=Tweet.count
  end
  

  def destroy
    @tweet=Tweet.find(params[:id])
    Log.new(:from=>current_user,:action=>'deleted tweet: '+@tweet.content, :to=>@tweet.user).save
    @tweet.destroy
    redirect_to :back

  end
end
