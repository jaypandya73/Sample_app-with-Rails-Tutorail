require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:sheldon)
    @other_user = users(:leonard)
  end

  test "Listing all user with pagination and with Admin" do
    log_in_as(@user)
    get users_path
    assert_template 'users/index'
    assert_select 'div.pagination'
    # User.paginate(page: 1).each do |user|
    #   assert_select 'a[href=?]', user_path(user), text: user.name
    # end
    first_page = User.paginate(page: 1)
    first_page.each do |user|
      assert_select 'a[href=?]' , user_path(user), text: user.name
    unless user == @user
    assert_select 'a[href=?]', user_path(user), text: 'delete'
    end
    end

    assert_difference 'User.count', -1 do
      delete user_path(@other_user)
    end 
  end



  test "Index for non admin" do
    log_in_as(@other_user)
    get users_path
    assert_template 'users/index'
    assert_select 'a', text: 'delete', count: 0
  end
end
