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
  
  has_many :tweets
  
  validates_uniqueness_of :name, :email, :case_sensitive => false
  
  def add_roles(roles)
    roles.uniq!
    self.roles=self.roles+roles
    save
  end
  
  def remove_roles(roles)
    self.roles=self.roles-roles
    save
  end
  
  def role?(role)
    return roles.include?(role)
  end
  
  protected

end