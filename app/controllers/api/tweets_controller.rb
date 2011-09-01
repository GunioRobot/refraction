class Api::TweetsController < ApplicationController
  def prerequest
    render_403 && return unless @remote_site=Site.where(hashed_public_key: params[:hash]).first
    @rand=rand(1000)
    RequestQueue.new(:rand=>@rand,:hash=>params[:hash]).save #save rand in request queue

    respond_to do |format|
      format.xml {render :xml=>{:rand=>@rand}}
    end
  end
  
  def create
    render_403 && return unless @remote_site=Site.where(hashed_public_key: params[:hash]).first
    rsa=OpenSSL::PKey::RSA.new(@remote_site.public_key)
    @content=rsa.public_decrypt(params[:content])

    rand=RequestQueue.where(hash: params[:hash]).last.rand #get last rand for this site

    if @content.starts_with?(rand) #decode successfully
      Tweet.new(:content=>@content).save
      format.xml {render :xml=>{:back=>'success'}}
    else
      render_403
    end         
  end
end
