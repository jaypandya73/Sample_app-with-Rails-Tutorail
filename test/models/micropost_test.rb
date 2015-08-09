require 'test_helper'

class MicropostTest < ActiveSupport::TestCase
  def setup
    @user = users(:sheldon)
    #@micropost = Micropost.new(content: "Like Twitter", user_id: @user.id) #not actually correct.
    @micropost = @user.microposts.new(content: "Like twitter")   #this takes right user_id value.
  end

  test "user should be valid" do
    assert @micropost.valid?
  end

  test "content should be there" do
    @micropost.content = " "
    assert_not @micropost.valid?
  end

  test "user id should be present" do
    @micropost.user_id = nil
    assert_not @micropost.valid?
  end

  test "content length validation" do
    @micropost.content = "a" * 141
    assert_not @micropost.valid?
  end

  test "most recent should be first" do
    assert_equal microposts(:most_recent), Micropost.first
  end

end
