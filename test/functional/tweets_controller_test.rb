require 'test_helper'

class TweetsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  
  def setup
    @request.env["devise.mapping"] = Devise.mappings[:user]
    @request.env["HTTP_REFERER"]='index_url'
    @tweet_owner=Factory.create(:user)
    @other_user=Factory.create(:user)
    @comment_owner=Factory.create(:user)
    @tweet=Factory(:tweet, :user=>@tweet_owner)

  end

  test 'others cannot delete a tweet' do  
    
    delete :destroy, :id=>@tweet.id
    assert_response 403, 'anaymous user cannot delete a tweet'
    @tweet=Factory(:tweet, :user=>@tweet_owner)
    sign_in @other_user
    delete :destroy, :id=>@tweet.id
    assert_response 403, 'other user cannot delete a tweet'
  end
  
  test 'owner can delete a tweet' do    
    @tweet=Factory(:tweet, :user=>@tweet_owner)
    sign_in @tweet_owner
    assert delete :destroy, :id=>@tweet.id
    assert_redirected_to 'index_url'
    assert_not_nil flash[:success]
    assert_nil flash[:error]
  end

  test "comment delete button should only appear for comment owner or tweet owner" do
    #do it later
  end

  test "others cannt see edit tweet page" do
    sign_in @other_user
    get :edit, :id=>@tweet.id
    assert_response 403
  end

  test "others cannot edit tweet" do
    sign_in @other_user
    put :update, :id=>@tweet.id
    assert_response 403
  end

  test "owner can see edit tweet page" do
    sign_in @tweet_owner
    get:edit, :id=>@tweet.id
    assert_response 200
  end

  test "owner can edit tweet page" do
    sign_in @tweet_owner
    put :update, :id=>@tweet.id
    assert_redirected_to tweet_url(@tweet.id)
    assert_not_nil flash[:success]
  end




end
