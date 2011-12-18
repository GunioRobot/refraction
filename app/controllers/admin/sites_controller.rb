class Admin::SitesController < ApplicationController
  before_filter :admin_needed
  include HTTParty

  def index
    @sites=Site.where(:this_site.ne=>true).order_by([[:created_at, :desc]])
  end

  def show
    @site=Site.find(params[:id])
    @circles=@site.circles
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
    #BUG: server will down, if ask localhost
    return if(params[:url]==@our_site.base_uri) #BUG: different domain name, same IP
    @r= HTTParty.post params[:url]+'/api/circle.xml', :body=>@our_site.to_hash #post our info to remote, get respond

    if @r.header.code=='200' #response success
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
          :public_key=>@r['public_key'], :hashed_public_key=>@r['hashed_public_key'],
          :base_uri=>@r['base_uri'])
        @site.circle='I circled'
        @site.save
      end
    end

    #TODO errors need to be handled
    @sites=Site.where(:this_site.ne=>true).order_by([[:created_at, :desc]])

    respond_to do |format|
      format.html {redirect_to admin_sites_url}
      format.js {render :layout=>false}
    end
  end

  def add_circles_to_site
    @site=Site.find(params[:id])
    @circles=params[:circles].split
    @circles.each do |c|
      c.strip!
      if c!=''
        circle=c
        begin
          c=Circle.new(:name=>c)
          c.save!
        rescue
          c=Circle.where(name: circle).first
        end
        @site.circles << c
      end
    end

    @circles=@site.circles
    respond_to do |format|
      format.html {redirect_to admin_site_url(@site)}
      format.js {render :layout=>false}
    end

  end

  def remove_circle_from_site
    @site=Site.find(params[:id])
    @site.circles.delete Circle.find(params[:circle])
    @circles=@site.circles

    respond_to do |format|
      format.html {redirect_to admin_site_url(@site)}
      format.js {render 'add_circles_to_site',:layout=>false}
    end
  end

end
