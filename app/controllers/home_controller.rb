class HomeController < ApplicationController
  def index
    @user=current_user if current_user
    @tweet=Tweet.new
    @tweets=Tweet.all.desc(:created_at)
    #@r_tweets=Tweet.get_all_stores
  end
  

end
