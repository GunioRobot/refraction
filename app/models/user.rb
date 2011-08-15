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
  references_many :comments
  
  validates_uniqueness_of :name, :email, :case_sensitive => false
  
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
  
  def role?(role)
    return self.roles.include?(role) if self.roles
    return false
  end
  
  def get_roles
    self.roles.join(', ')
  end


  
  protected

end
