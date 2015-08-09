require 'test_helper'

class RelationshipsControllerTest < ActionController::TestCase

  test "follow should be only on logged user" do
  	assert_no_difference 'Relationship.count' do
  		post :create
  	end
  	assert_redirected_to login_url
  end

  test "unfollow should be only on logged user" do
  	assert_no_difference 'Relationship.count' do
  		post :destroy, id: relationships(:one)
  	end
  	assert_redirected_to login_url
  	end

end

