require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:sheldon)
  end

  test "For Unsuccessful editing" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), user: { name: "",
                                    email: "iam#invalid", 
                                     password: "hello", 
                                     password_confirmation: "byebye"
                                   }
    
    assert_template 'users/edit'

  end

  test "For Successful edit information" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    name = 'jay'
    email = 'jay@mail.com'
    patch user_path(@user), user: {name: name, email: email, password: "",
                                    password_confirmation: ""    }
    assert_not flash.empty?
    #assert_template 'users/show'
    assert_redirected_to @user
    @user.reload
    assert_equal name, @user.name
    assert_equal email, @user.email

  end

  test "Test for friendly forwarding" do
    get edit_user_path(@user)
    log_in_as(@user)
    assert_redirected_to edit_user_path(@user)
    name = 'jay'
    email = 'jay@mail.com'
    patch user_path(@user), user: {name: name, email: email, password: "",
                                    password_confirmation: ""    }
    assert_not flash.empty?
    #assert_template 'users/show'
    assert_redirected_to @user
    @user.reload
    assert_equal name, @user.name
    assert_equal email, @user.email
  end

  test "Test for friendly forwarding with assurance of storage location" do
    get edit_user_url(@user)
    
    assert_equal session[:forwarding_url], edit_user_url(@user)
    log_in_as(@user)
    #debugger
    assert_equal session[:forwarding_url], nil
    assert_redirected_to edit_user_url(@user)

    name = 'jay'
    email = 'jay@mail.com'
    patch user_path(@user), user: {name: name, email: email, password: "",
                                    password_confirmation: "" }
    assert_not flash.empty?
   
    #assert_template 'users/show'
    assert_redirected_to @user
    @user.reload
    assert_equal name, @user.name
    assert_equal email, @user.email
  end



end
