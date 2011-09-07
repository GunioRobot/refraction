module Api::SitesHelper
  def get_site_info(base_uri,site_id)
    r=HTTParty.get base_uri+'/api/sites/'+site_id+'.xml'
    r['site']
  end
end
