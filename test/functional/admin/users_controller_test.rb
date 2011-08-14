require 'test_helper'

class Admin::UsersControllerTest < ActionController::TestCase
  def setup
    @request.env["devise.mapping"] = Devise.mappings[:user]
    @other_user=Factory :user
    @admin_user=Factory :user
    @admin_user.add_roles!('admin')
  end  
  
  
  test "the truth" do
    assert true
  end
end
