class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include Gravtastic
  gravtastic :rating => 'G', :size => 48
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  
  attr_accessible :email, :password, :password_confirmation, :name,:login
  attr_accessor :login
  
  field :roles, :type=>Array
  field :name
  field :email
  field :super, :type=>Boolean, :default=>0
  field :blocked, :type=>Boolean, :default=>0
  
  has_many :tweets
  references_many :comments
  has_and_belongs_to_many :circles
  
  validates_uniqueness_of :name, :email, :case_sensitive => false
  before_save :before_save
  
  def before_save
    self.super=true unless User.first
    add_roles!('admin') if super?&&!role?('admin')
  end
  
  def change_block!
    self.blocked=!self.blocked
    save
  end
  
  def blocked?
    self.blocked
  end
  
  def set_super!
    self.super=true
    add_roles!('admin')
    save
  end
  
  def super?
    self.super
  end
  
  def add_roles!(roles)
    roles=roles.split
    self.roles=Array.new unless self.roles
    self.roles=self.roles+roles
    self.roles.uniq!
    save
  end
  
  def remove_roles!(roles)
    roles=roles.split
    self.roles=self.roles-roles    
    self.roles.uniq!
    save
  end

  def reset_roles!(roles)
    self.roles=roles.split.uniq if roles
    save
  end
  
  def role?(role)
    return self.roles.include?(role) if self.roles
    return false
  end
  
  def get_roles
    return self.roles.join(', ') if self.roles
    return ''
  end

  


  
  protected

end
