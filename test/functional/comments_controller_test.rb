require 'test_helper'

class CommentsControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  
  def setup
    @request.env["devise.mapping"] = Devise.mappings[:user]
    @request.env["HTTP_REFERER"]='index_url'

    @tweet_owner=Factory.create(:user)
    @comment_owner=Factory.create(:user)
    @other_user=Factory.create(:user)
    
    @tweet=Factory :tweet, :user=>@tweet_owner
    @comment=Factory :comment,:user=>@comment_owner, :tweet=>@tweet
  end

  test "other user cannot delete a comment" do
    assert delete :destroy, :id=>@comment.id
    assert_response 403, 'other user cannot delete a comment'
    sign_in @other_user
    assert delete :destroy, :id=>@comment.id
    assert_response 403, 'other user cannot delete a comment'
  end

  test "comment owner can delete a comment" do
    sign_in @comment_owner
    assert delete :destroy, :id=>@comment.id
    assert_redirected_to 'index_url'
    assert_not_nil flash[:success], 'comment owner can delete a comment'
  end

  test "tweet owner can delete comments" do
    sign_in @tweet_owner
    assert delete :destroy, :id=>@comment.id
    assert_redirected_to 'index_url'
    assert_not_nil flash[:success], 'tweet owner can delete comments'
  end

  
end
