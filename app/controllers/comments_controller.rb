class CommentsController < ApplicationController
  def create
    begin
      @tweet=Tweet.find(params[:tweet_id])
    rescue
      render_404
      return
    end
    if @tweet.user
      if params[:hashed_public_key]
        site=Site.where(hashed_public_key: params[:hashed_public_key]).first
        comment=@tweet.comments.new(:content=>site.public_decrypt(params[:content]))
        comment.site_id=site.id
        comment.save!
      else
        @comment=@tweet.comments.new(params[:comment])
        @comment.user=current_user
        if @comment.save
          flash[:success]='success';
        else
          flash[:error]='error';
        end
      end
    else
      content=params[:comment]['content']
      remote_site=@tweet.site
      our_site=Site.where(this_site: true).first
      tweet_id=@tweet.id_in_sender
      content=our_site.private_encrypt(content)
      HTTParty.post remote_site.base_uri+'/tweets/'+tweet_id+'/comments.xml',
        :body=>{:content=>content,:hashed_public_key=>our_site.hashed_public_key}
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

  def index
    @tweet=Tweet.find(params[:tweet_id])
    @comments=@tweet.comments.all.order_by([:created_at, :desc])
    respond_to do |format|
      format.xml {render :xml=>@comments}
    end
  end

end
