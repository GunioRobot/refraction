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

  def destroy
    @comment=Comment.find(params[:id])
    render_403&&return unless @comment.user==current_user||@comment.tweet.user==current_user #only owner or tweet owner can delete
    if @comment.destroy
      flash[:success]=t('.Deleted successfully')
    else
      flash[:error]=t('.Failed, please try again')
    end
    redirect_to :back

  end

end
