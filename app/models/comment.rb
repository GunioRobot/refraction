class Comment
  include Mongoid::Document
  include Mongoid::Timestamps
  
  referenced_in :tweet
  referenced_in :user
  
  field :content
  
  validates_presence_of :content, :user, :tweet
  attr_accessible :content
  
end
