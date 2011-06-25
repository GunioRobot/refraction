class User
  include Mongoid::Document
  include Mongoid::Timestamps
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  
  attr_accessible :email, :password, :password_confirmation
  
  field :roles, :type=>Array
  
  
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

end
