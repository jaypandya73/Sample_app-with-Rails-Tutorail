require 'test_helper'

class MicropostsControllerTest < ActionController::TestCase

  def setup
    @micropost = microposts(:political)
  end

  test "should redirect to create when not logged in" do
    assert_no_difference "Micropost.count" do
      post :create, micropost: { content: "Like Twitter." }
    end
    assert_redirected_to login_url
  end

  test "should redirect to destroy when not logged in" do
    assert_no_difference "Micropost.count" do
      delete :destroy, id: @micropost
    end
    assert_redirected_to login_url
  end

  test "should redirect home when wrong user try to destroy other's post" do
    log_in_as(users(:sheldon))
    micropost = microposts(:sports)
    assert_no_difference 'Micropost.count' do
      delete :destroy, id: micropost
    end
    assert_redirected_to root_url
  end
end
