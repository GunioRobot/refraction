class Api::TweetsController < ApplicationController

  '''Return a rand string to requester first.
     not using due to bad performance'''
  def prerequest
    render_403 && return unless @remote_site=Site.where(hashed_public_key: params[:hash]).first
    @rand=rand(1000)
    logger.debug @rand
    RequestQueue.new(:rand=>@rand,:hash=>params[:hash]).save #save rand in request queue

    respond_to do |format|
      format.xml {render :xml=>{:rand=>@rand}}
    end
  end

  def create
    render_403 && return unless requester_site=Site.where(hashed_public_key: params[:hash]).first
    begin
      content=requester_site.public_decrypt(params[:content])
      tweet=Tweet.new(:content=>content)
      tweet.site=requester_site
      tweet.save!
    rescue
      render_403
    end

  end
end
