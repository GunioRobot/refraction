require 'test_helper'

class TweetTest < ActiveSupport::TestCase
  def setup
    @user=Factory :user
  end

  test 'only owner can delete' do
    #TODO
  end

  test 'delete all comments when the tweet deleted' do
    @tweet=Factory :tweet
    @comment1=Factory :comment, :tweet=>@tweet
    @comment2=Factory :comment, :tweet=>@tweet
    assert @tweet.comments.all.count==2
    @tweet.destroy
    assert Comment.all.count==0
  end

  test 'tweet with same id and hash caanot insert' do
    @site=Factory :site
    @tweet=Factory :tweet, :site=>@site
    @tweet.save

    @t=Factory :tweet, :site=>@site
    assert_raise('already have')  {@t.save}
  end



end
