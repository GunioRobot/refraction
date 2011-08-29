class Site
  include Mongoid::Document
  include Mongoid::Timestamps

  field :public_key
  field :private_key
  field :key_created_at
  field :site_name
  field :this_site, :type=>Boolean
  field :site_description
  field :circle, :type=>Integer #0: in my circle, 1: circled me, 2: two directions
  
  before_save :before_save
  
  def before_save
    key_created_at=updated_at if public_key_changed?||private_key_changed?
  end

end
