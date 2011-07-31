class CommentsController < ApplicationController
  def create

    begin
      @tweet=Tweet.find(params[:tweet_id])
    rescue
      render_404
      return
    end
    @comment=@tweet.comments.new(params[:comment])
    @comment.user=current_user
    if @comment.save
      flash[:success]='success';
    else
      flash[:error]='error';
    end
    redirect_to tweet_url(@tweet)
  end
end
