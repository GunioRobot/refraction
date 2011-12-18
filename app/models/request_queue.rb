class RequestQueue
  include Mongoid::Document
  include Mongoid::Timestamps

  field :hash
  field :rand
end
