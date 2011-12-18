require 'digest/md5'

class Tweet
  include Mongoid::Document
  include Mongoid::Timestamps
  include HTTParty

  field :content
  field :title
  field :closed, :type=>Boolean, :default=>false
  field :hash
  field :id_in_sender
  field :circle, :type=>Array


  belongs_to :user
  belongs_to :site
  references_many :comments
  has_one :retweet, :class_name=>'Tweet'

  validates_presence_of :content

  attr_accessible :content

  before_destroy :delete_comments
  before_save :before_save

  def before_save
    if(self.site_id) #if this is from other site
      hash=Digest::MD5.hexdigest(self.content) #content=id+content
      self.hash=hash
      self.id_in_sender=self.content.match(/^([a-z0-9]+)\$\$\$/)[1]
      raise 'already have this' if Tweet.where(hash: hash).and(site_id: site_id).first
      self.content=self.content.sub(/^[a-z0-9]+\$\$\$/,'')
    end
  end

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
