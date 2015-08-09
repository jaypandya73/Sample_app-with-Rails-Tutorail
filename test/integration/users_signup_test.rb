require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  def setup
    ActionMailer::Base.deliveries.clear
  end
 
  test "invalid signup information" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path , user: {name:" ",email: "jay#mail", password: "hello", password_confirmation: "byebye"}
    end
    assert_template 'users/new'  
    assert_select 'div#error_explanation'
    assert_select 'div.alert.alert-danger'   

  end

  test "valid signup information" do
    get signup_path
    assert_difference 'User.count',1 do
    post_via_redirect users_path, user: {name: "jay", email: "jay@mail.com", 
                                    password: "12345678", password_confirmation: "12345678"}
    end
    # assert_template 'users/show'
    # assert_not flash[:danger]
    # assert is_logged_in?
  end
  test "valid signup with account activation" do
    get signup_path
    assert_difference 'User.count',1 do
    post users_path, user: {name: "jay", email: "jay@mail.com",
                                       password: "12345678", password_confirmation: "12345678" }
  end
  assert_equal 1, ActionMailer::Base.deliveries.size
  user = assigns(:user)
  assert_not user.activated?
  log_in_as(user)       #try to log in
  assert_not is_logged_in?  #not log in because not activated
  get edit_account_activation_path('invalid token')   #invalid token
  assert_not is_logged_in?         #invalid token so not activated.
  get edit_account_activation_path(user.activation_token,email: 'wrong email')
  assert_not is_logged_in?
  get edit_account_activation_path(user.activation_token, email: user.email)
  assert user.reload.activated?
  follow_redirect!
  assert_template 'users/show'
  assert is_logged_in?
  end
end