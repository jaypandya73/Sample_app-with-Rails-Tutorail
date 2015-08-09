require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @user = User.new(name: "user name", email: "user@mail.com",
                      password: "jpjpjpjp", password_confirmation: "jpjpjpjp")
  end

  test "should be valid" do
    assert @user.valid? 
  end
  test "name should be present" do
    @user.name = ""
    assert_not @user.valid?
  end
  test "email should be present" do
    @user.email = "    "
    assert_not @user.valid?
  end
  test "name should not be too long" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end

  test "email should not be too long" do
    @user.email = "a" * 244 + "@mail.com"
    assert_not @user.valid?
  end

    test "email validation should accept valid addresses" do
    valid_addresses = %w[user@mail.com USER@mail.com U_ser@foo.org first.last@mail.com]
    valid_addresses.each do |valid1|
      @user.email = valid1
      assert @user.valid?, "#{valid1.inspect} should be valid"
    end
  end
    test "email validation should reject valid addresses" do
    invalid_addresses = %w[user@mail,com USER#mail.com U_ser@foo.doo_org first,last@mail.com]
    invalid_addresses.each do |invalid|
      @user.email = invalid
      assert_not @user.valid?, "#{invalid.inspect} should be valid"
    end
  end

    test "email address should be unique" do 
      duplicate_user = @user.dup
      duplicate_user.email = @user.email.upcase
      @user.save
      assert_not duplicate_user.valid?
    end

    test "email address should be saved as lower case" do
      mix_email = "UseR@gMaIl.coM"
      @user.email = mix_email
      @user.save
      assert_equal mix_email.downcase, @user.reload.email 
    end

    test "password should be present and non-blank" do
      @user.password = @user.password_confirmation = " " * 6
      assert_not @user.valid?
    end

    test "password should have minimum length" do
      @user.password = @user.password_confirmation = "j" * 5
      assert_not @user.valid?
    end
    
    test "authenticated? should return false for nil digest" do
      assert_not @user.authenticated?(:remember,'')
    end

    test "associated micropost should be destroy" do
      @user.save
      @user.microposts.create!(content: "Like Twitter.")
      assert_difference "Micropost.count", -1 do
        @user.destroy
      end
    end

    test "should follow user" do
      sheldon = users(:sheldon)
      jay = users(:jay)
      assert_not sheldon.following?(jay)
      sheldon.follow(jay)
      assert sheldon.following?(jay)
      assert jay.followers.include?(sheldon)
      sheldon.unfollow(jay)
      assert_not sheldon.following?(jay)
    end

end
