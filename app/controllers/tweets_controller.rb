class TweetsController < ApplicationController
  def create
    @tweet=Tweet.new(params[:tweet])
    @tweet.user=current_user
    if @tweet.save
      redirect_to root_url, :notice=>t(:tweet_saved)      
    else
      render 'home/index'
    end
  end
end
