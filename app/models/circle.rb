class Circle
  include Mongoid::Document
  
  has_and_belongs_to_many :users
  has_and_belongs_to_many :sites
  
  field :name
  
  validates :name, :uniqueness => true
  
  
end
