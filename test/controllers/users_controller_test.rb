require 'test_helper'

class UsersControllerTest < ActionController::TestCase

  def setup
    @user = users(:sheldon)
    @other_user = users(:leonard)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should redirect to edit when not logged in" do
    get :edit, id: @user   #user.id take automatically rails convention.
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect to update when not logged in" do
    patch :update, id: @user, user: {name: @user.name, email: @user.email }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect to edit when wrong user" do
    log_in_as(@other_user)
    get :edit, id: @user
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect to update when wrong user" do
    log_in_as(@other_user)
    patch :update, id: @user, user: {name: @other_user.name, email: @other_user.email}
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should get index when not logged in" do
    get :index
    assert_redirected_to login_url
  end

  test "should get login page when not logged in" do
    assert_no_difference 'User.count' do
      delete :destroy, id: @user
    end
    assert_redirected_to login_url
  end

  test "should get root url when try to delete user and not admin" do
    log_in_as(@other_user)
    assert_no_difference 'User.count' do
      delete :destroy, id: @user
    end

    assert_redirected_to root_url
  end

  test "admin attribute not edited by web" do
    log_in_as(@other_user)
    assert_not @other_user.admin?
    patch :update, id: @other_user, user: {password: 'asdfghjkl', password_confirmation: 'asdfghjkl',admin: false}
    assert_not @other_user.reload.admin?  
  end
end
