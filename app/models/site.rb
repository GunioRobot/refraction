require "openssl"
require 'digest/md5'

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
  field :email
  field :logo_path
  field :error_time, :type=>Integer  
  
  before_save :before_save
  has_many :tweets
  has_and_belongs_to_many :circles
  
  def before_save
    key_created_at=updated_at if public_key_changed?||private_key_changed?
  end

  def to_hash
    {:public_key=>public_key, :hashed_public_key=>hashed_public_key,:site_name=>site_name, :site_description=>site_description,
      :base_uri=>base_uri, :email=>email
    }
  end
  
  #regenerate key pairs and hashed public key
  def regernate_keys
    return false unless this_site
    rsa = OpenSSL::PKey::RSA.new(2048)
    self.public_key, self.private_key = rsa.public_key.to_pem, rsa.to_pem
    self.hashed_public_key=Digest::MD5.hexdigest(public_key)
    save
  end
  
  def private_encrypt(string)
    rsa=OpenSSL::PKey::RSA.new(private_key)
    rsa.private_encrypt(string)
  end
  
  def private_decrypt(string)
    rsa=OpenSSL::PKey::RSA.new(private_key)
    rsa.private_decrypt(string)
  end
  
  def public_encrypt(string)
    rsa=OpenSSL::PKey::RSA.new(public_key)
    rsa.public_encrypt(string)
  end
  
  def public_decrypt(string)
    rsa=OpenSSL::PKey::RSA.new(public_key)
    rsa.public_decrypt(string)
  end

end
