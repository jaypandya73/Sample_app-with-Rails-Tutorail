require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest

    def setup
      @user = users(:sheldon)
    end

   test "login via invalid information" do

    get login_path
    assert_template 'sessions/new'
    post login_path, session: { email: "", password: "" }
    assert_template 'sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?

  end


  test "login with valid information followed by logout" do
    get login_path
    post login_path, session: { email: @user.email, password: 'asdfghjkl' }
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_url
    delete logout_path
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path, count: 0
    assert_select 'a[href=?]', user_path(@user), count: 0
  end
  
  test "Log in with remember" do
    log_in_as(@user,remember_me: '1')
    assert_equal cookies['remember_token'], assigns(:user).remember_token #assigns(:user) = @user
    #assert_not_nil cookies['remember_token']
  end
  test "Log in without remember" do
    log_in_as(@user,remember_me: '0')
    assert_nil cookies['remember_token']
  end
end