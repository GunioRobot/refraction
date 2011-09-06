class Comment
  include Mongoid::Document
  include Mongoid::Timestamps
  
  referenced_in :tweet
  referenced_in :user
  referenced_in :site
  
  field :content
  
  validates_presence_of :content, :tweet
  attr_accessible :content
  
end
