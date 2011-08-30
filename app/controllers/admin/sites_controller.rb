class Admin::SitesController < ApplicationController
  before_filter :admin_needed
  include HTTParty
  
  def index
    @sites=Site.where(:this_site.ne=>true).order_by([[:created_at, :desc]])
  end
  
  def circled_you
    @sites=Site.where(circle: 'circled me').order_by([[:created_at, :desc]])
    render 'index'
  end
  
  def you_circled
    @sites=Site.where(circle: 'I circled').order_by([[:created_at, :desc]])
    render 'index'
  end
  
  def circled_each_other
    @sites=Site.where(circle: 'circled each other').order_by([[:created_at, :desc]])
    render 'index'
  end

  def create
    @our_site=Site.where(this_site: true).first #our site info
    @r= HTTParty.post params[:url], :body=>@our_site.to_hash #post our info to remote, get respond
    @r=@r['site']
    
    if(@site=Site.where(hashed_public_key: @r['hashed_public_key']).first) #if this site exist in database
      if @site.circle=='circled me' #if this site circled our before
        @site.circle='circled each other'
      else
        @site.circle='I circled'
      end
      @site.save
    else
      @site=Site.new(:site_name=>@r['site_name'],:site_description=>@r['site_description'],
        :public_key=>@r['public_key'], :hashed_public_key=>@r['hashed_public_key'])
      @site.circle='I circled'
      @site.save
    end
    
      
    @sites=Site.where(:this_site.ne=>true).order_by([[:created_at, :desc]])

    respond_to do |format|
      format.html {redirect_to admin_sites_url}
      format.js {render :layout=>false}
    end
  end
end
