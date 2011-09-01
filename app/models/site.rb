class Site
  include Mongoid::Document
  include Mongoid::Timestamps
  

  field :public_key
  field :private_key
  field :hashed_public_key
  field :key_created_at
  field :site_name
  field :this_site, :type=>Boolean
  field :site_description
  field :base_uri
  field :circle
  field :remarks
  field :logo_path
  field :error_time, :type=>Integer  
  
  before_save :before_save
  
  def before_save
    key_created_at=updated_at if public_key_changed?||private_key_changed?
  end

  def to_hash
    {:public_key=>public_key, :hashed_public_key=>hashed_public_key,:site_name=>site_name, :site_description=>site_description,
      :site_uri=>base_uri
    }
  end

end
