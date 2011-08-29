class Tweet
  include Mongoid::Document
  include Mongoid::Timestamps
  include HTTParty
  
  field :content
  field :title
  field :closed, :type=>Boolean, :default=>false
  
  belongs_to :user
  references_many :comments
  has_one :retweet, :class_name=>'Tweet'

  validates_presence_of :content, :user
  
  attr_accessible :content

  before_destroy :delete_comments

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
  
  def delete_comments
    self.comments.destroy
  end

  #########

  def self.get_all_stores
    get("http://0.0.0.0:3000/tweets.xml")
  end
  
end
