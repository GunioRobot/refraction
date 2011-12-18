
Factory.define :user do |user|
  user.sequence(:name) {|n| "user_#{n}"}
  user.sequence(:email) {|n| "user#{n}@local.me"}
  user.password 'password'
  user.password_confirmation 'password'
end

Factory.define :tweet do |tweet|
  tweet.title 'title'
  tweet.content 'content'
  tweet.hash 'hash'
  tweet.association :user
  tweet.association :site
end



Factory.define :comment do |comment|
  comment.content 'content'
  comment.association :user
  comment.association :tweet
end

Factory.define :site do |site|

end