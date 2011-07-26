class Tweet
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :content
  field :title
  
  belongs_to :user
  
  
end