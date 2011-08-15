class Admin::TweetsController < ApplicationController
  before_filter :admin_needed

  def index
    @tweets=Tweet.all.paginate :page=>params[:page], :per_page=>20
    @count=Tweet.count
  end

  def destroy
    @tweet=Tweet.find(params[:id])
    @tweet.destroy
    redirect_to :back

  end
end
