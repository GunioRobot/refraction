require 'test_helper'

class TweetsControllerTest < ActionController::TestCase
  include Devise::TestHelpers


  def setup
    @request.env["devise.mapping"] = Devise.mappings[:user]
    @request.env["HTTP_REFERER"]='index_url'
    @tweet_owner=Factory.create(:user)
    @tweet_owner.add_roles!('admin editor')
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
    #@tweet=Factory(:tweet, :user=>@tweet_owner)
    puts @tweet_owner.name
    puts @tweet.user.name
    sign_in @tweet_owner
    assert @tweet_owner==@tweet.user
    assert @tweet_owner.role?('admin')
    assert @tweet_owner.role?('editor')
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

  test "test show" do
    #get :show, :id=>@tweet.id
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

  test "editor can see the submit form" do
    #TODO
  end

  test "others cannt see the submit form" do
    #TODO
  end

  test "non-permission user cannt post a tweet" do
    sign_in @other_user
    post :create
    assert_response 403
  end

  test "editor can post a tweet" do
    @other_user.add_roles!('editor')
    sign_in @other_user
    post :create,:tweet => {:content=>'abc'}
    assert_response 302
    #assert_redirected_to 'index_url'
  end



end
