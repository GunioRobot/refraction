class Tweet
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :content
  field :title
  field :closed, :type=>Boolean, :default=>true
  
  belongs_to :user
  references_many :comments

  validates_presence_of :content, :user, :comment_open


  def open?
    !self.closed
  end

  def close?
    self.closed
  end

  def close!
    self.closed=true
    save
  end

  def open!
    self.close=false
  end
  

  
end
