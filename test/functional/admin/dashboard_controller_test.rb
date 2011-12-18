require 'test_helper'

class Admin::DashboardControllerTest < ActionController::TestCase
  def setup
    @request.env["devise.mapping"] = Devise.mappings[:user]
    @other_user=Factory :user
    @admin_user=Factory :user
    @admin_user.add_roles!('admin')
  end

  test "others cann't access" do
    #get :show
    #assert_response 403
    sign_in @other_user
    get :show
    assert_response 403
  end

  test "admin can access" do
    sign_in @admin_user
    get :show
    assert_response 200
  end

end
