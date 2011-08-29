require "openssl"

class Admin::SiteController < ApplicationController
  def index
    @site=Site.new({'this_site'=>true}) unless @site=Site.where(this_site: true).first
    
    unless(@site.public_key&&@site.private_key)
      rsa = OpenSSL::PKey::RSA.new(2048)
      @site.public_key, @site.private_key = rsa.public_key.to_pem, rsa.to_pem
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
    redirect_to admin_site_config_url
  end
  
  def regenerate_keys
    @site=Site.where(this_site: true).first
    rsa = OpenSSL::PKey::RSA.new(2048)
    @site.public_key, @site.private_key = rsa.public_key.to_pem, rsa.to_pem
    @site.save
    respond_to do |format|
      format.html {redirect_to admin_site_config_url}
      format.js {render :layout=>false}
    end
  end
  
end
