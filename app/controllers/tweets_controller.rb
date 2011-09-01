require "openssl"

class TweetsController < ApplicationController
  before_filter :permission, :only=>[:create, :edit, :upadte, :destroy]
  include HTTParty
  
  def create
    @tweet=Tweet.new(params[:tweet])
    @tweet.user=current_user
    @private_key=Site.where(this_site: true).first.private_key
    if @tweet.save
      @sites=Site.where(:circle.in=>['circled each other', 'circled me'])
      @sites.each do |s|
        @r=HTTParty.post s.base_uri+'/api/tweets/prerequest.xml', :body=>{:action=>'post request', :hash=>s.hashed_public_key}
        
        #TODO: bad performance, need improve
        rsa = OpenSSL::PKey::RSA.new(@private_key)
        content=rsa.private_encrypt(@r['hash']['rand'].to_s+@tweet.content)
        @r=HTTParty.post s.base_uri+'/api/tweets.xml', :body=>{:action=>'post content', :content=>rsa.private_encrypt(@r['hash']['rand'].to_s+@tweet.content), :hash=>s.hashed_public_key}
        
        flash[:success]=OpenSSL::PKey::RSA.new(Site.where(this_site: true).first.public_key).public_decrypt(content).to_s
      end
      
      redirect_to root_url, :notice=>t(:tweet_saved)      
    else
      render 'home/index'
    end
  end
  
  def show
    #puts 'abc'
    @tweet=Tweet.find(params[:id])
    @comment=Comment.new
    @comments=@tweet.comments.all.order_by([:created_at, :desc])
    @comments_num=@tweet.comments.count
    
  end

  def edit
    begin
      @tweet=current_user.tweets.find(params[:id])
    rescue
      render_403
      return
    end
  end

  def update
    begin
      @tweet=current_user.tweets.find(params[:id])
    rescue
      render_403
      return
    end
    
    if @tweet.update_attributes params[:tweet]
      flash[:success]=t(".Edited successfully")
      redirect_to tweet_url(@tweet)
    else
      render :edit
    end

  end

  def destroy
    @tweet=Tweet.find(params[:id])
    puts @tweet.user.name
    puts current_user.name
    puts @tweet.user==current_user
    render_403&&return unless @tweet.user==current_user
    if @tweet.destroy
      flash[:success]=t('.Deleted successfully')      
    else
      flash[:error]=t('.Failed, please try again')
    end
    redirect_to :back
  end
  
  
  def permission
    render_403 unless can?(:manage, Tweet)
  end

  def index
    @tweets=Tweet.all
    respond_to do |format|
      format.xml {render :xml=> @tweets}
    end
  end
 
  


end
