
Factory.define :user do |user|
  user.sequence(:name) {|n| "user_#{n}"}
  user.sequence(:email) {|n| "user#{n}@local.me"}
  user.password 'password'
  user.password_confirmation 'password'
end

Factory.define :tweet do |tweet|
  tweet.title 'title'
  tweet.content 'content'
  tweet.closed true
  tweet.association :user
end



Factory.define :comment do |comment|
  comment.content 'content'
  comment.association :user
  comment.association :tweet
end
=begin
Factory.define :reply do |reply|
  reply.content 'content'
  reply.association :user
  reply.association :topic
end

Factory.define :status_base, :class => Status::Base do |s|
  s.association :user
end

Factory.define :status_reply, :class => Status::Reply do |s|
  s.association :user
  s.association :topic
  s.association :reply
end

Factory.define :status_topic, :class => Status::Topic do |s|
  s.association :user
  s.association :topic
end
=end
