require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:leonard)
  end
  test "layout links" do
      get root_path
      assert_template 'static_pages/home'
      assert_select "a[href=?]", root_path, count: 2
      assert_select "a[href=?]", help_path
      assert_select "a[href=?]", about_path
      assert_select "a[href=?]", contact_path
      get signup_path
      assert_select "title", full_title("Sign Up")

      #Exercise start from here.

      assert_select "a[href=?]", logout_path, count: 0  
      assert_select "a[href=?]", users_path, count: 0
      assert_select "a[href=?]", edit_user_path(@user), count: 0

      assert_select "a[href=?]", login_path
      get login_path
      post login_path, session: { email: @user.email, password: 'asdfghjkl' }
      #log_in_as(@user)
      assert_redirected_to @user
      follow_redirect!
      assert_template 'users/show'
      assert_select "a[href=?]", login_path, count: 0
      assert_select "a[href=?]", logout_path
      assert_select "a[href=?]", users_path
      assert_select "a[href=?]", user_path(@user)
      assert_select "a[href=?]", edit_user_path(@user)
      delete logout_path
  end
end
