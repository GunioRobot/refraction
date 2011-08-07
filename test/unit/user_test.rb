require 'test_helper'

class UserTest < ActiveSupport::TestCase
  
  def setup
    @user=Factory :user
    @user.add_roles!('a b c d')
  end
  
  test 'add roles to user' do
    @user.add_roles!("admin editor")
    assert @user.role?('admin')
    assert @user.role?('editor')
  end
  
  test 'remove roles to user' do
    assert @user.role?('a')
    assert @user.role?('b')
    assert @user.role?('c')
    @user.remove_roles!('a b')
    assert !@user.role?('a')
    assert !@user.role?('b')
    assert @user.role?('c')
    @user.remove_roles!('d c')
    assert !@user.role?('c')
  end
  
end
