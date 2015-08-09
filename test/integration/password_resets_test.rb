require 'test_helper'

class PasswordResetsTest < ActionDispatch::IntegrationTest
  def setup
    ActionMailer::Base.deliveries.clear
    @user = users(:sheldon)
  end

  test "password reset" do
    get new_password_reset_path
    assert_template 'password_resets/new'
    #now for invalid email entry
    post password_resets_path, password_reset: { email:" " }
    assert_not flash.empty?
    assert_template 'password_resets/new'
    #now for valid email entry
    post password_resets_path, password_reset: {email:@user.email}
    assert_not_equal @user.reset_digest, @user.reload.reset_digest
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_not flash.empty?
    assert_redirected_to root_url
    # setup
    user = assigns(:user)
    #now editing with wrong email
    get edit_password_reset_path(user.reset_token,email: " ")
    assert_redirected_to root_url
    #now for inactive user
    user.toggle!(:activated)
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_redirected_to root_url
    user.toggle!(:activated)
    #now right email wrong token
    get edit_password_reset_path("wrong token", email: user.email)
    assert_redirected_to root_url
    #now right email right token
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_template 'password_resets/edit'
    assert_select "input[name=email][type=hidden][value=?]", user.email
    #now invalid password
    patch password_reset_path(user.reset_token),
          email: user.email,
          user: { password: 'wrong', password_confirmation: 'totally' }
    assert_select 'div#error_explanation'
    #empty password
    patch password_reset_path(user.reset_token),
          email: user.email,
          user: {password: '', password_confirmation: ''}
    assert_not flash.empty?
    assert_template 'password_resets/edit'
    #valid password
    patch password_reset_path(user.reset_token),
          email: user.email,
          user: { password: '123456789', password_confirmation: '123456789' }
    assert is_logged_in?
    assert_not flash.empty?
    assert_redirected_to user


  end
end
