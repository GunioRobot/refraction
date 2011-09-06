require 'digest/md5'

class Api::SitesController < ApplicationController

  #ohter site request key exchange
  def circle
    @p=params
    @our_site=Site.where(this_site: true).first
    @our_site.private_key=nil

    if(@site=Site.where(hashed_public_key: params[:hashed_public_key]).first)  #if this site already in my list
      if @site.circle=='I circled'
        @site.circle='circled each other'
      else
        @site.circle='circled me'
      end

      #bug: temp solution, big security bug. auth needed
      @site.update_attributes(:site_name=>params[:site_name],
        :site_description=>params[:site_description],
        :base_uri=>params[:base_uri],:email=>params[:email])
      @site.save
    else
      @site=Site.new(:public_key=>params[:public_key],:site_name=>params[:site_name],
        :site_description=>params[:site_description],:hashed_public_key=>params[:hashed_public_key],
        :base_uri=>params[:base_uri],:email=>params[:email])
      render_403 unless @site.hashed_public_key==Digest::MD5.hexdigest(@site.public_key)
      @site.circle='circled me'
      @site.save
    end

    respond_to do |format|
      format.xml {render :xml=>@our_site, :layout=>false}
    end
  end

  #return a private encrypted base_uri
  def base_uri
    @base_uri=Site.where(this_site: true).first
    

  end

end
