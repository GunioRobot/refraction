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
  
  def show
    @tweet=Tweet.find(params[:id])
    @comment=Comment.new
    @comments=@tweet.comments.all.order_by([:created_at, :desc])
    @comments_num=@tweet.comments.count
  end
end
