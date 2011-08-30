require "openssl"
require 'digest/md5'

class Admin::SiteController < ApplicationController
  before_filter :admin_needed

  def index
    @site=Site.new({'this_site'=>true}) unless @site=Site.where(this_site: true).first
    
    unless(@site.public_key&&@site.private_key)
      rsa = OpenSSL::PKey::RSA.new(2048)
      @site.public_key, @site.private_key = rsa.public_key.to_pem, rsa.to_pem
      @site.hashed_public_key=Digest::MD5.hexdigest(@site.public_key)
      @site.save
    end
  end
  
  def update_site
    if Site.where(this_site: true).count==0
      @site=Site.new(params[:site])
      @site.this_site=true
      @site.save         
    else
      @site=Site.where(this_site: true).first
      @site.update_attributes params[:site]
    end
    flash[:success]=t(".updated successfully")
    Log.new(:from=>current_user, :action=>'changed site title: '+@site.site_name+', description: '+@site.site_description).save
    redirect_to admin_site_config_url
  end
  
  def regenerate_keys
    @site=Site.where(this_site: true).first
    rsa = OpenSSL::PKey::RSA.new(2048)
    @site.public_key, @site.private_key = rsa.public_key.to_pem, rsa.to_pem
    @site.hashed_public_key=Digest::MD5.hexdigest(@site.public_key)
    @site.save
    Log.new(:from=>current_user, :action=>'re-generated key pairs').save
    respond_to do |format|
      format.html {redirect_to admin_site_config_url}
      format.js {render :layout=>false}
    end
  end
  
end
