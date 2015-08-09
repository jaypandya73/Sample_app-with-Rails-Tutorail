require 'test_helper'

class FollowingTest < ActionDispatch::IntegrationTest

	def setup
		@user = users(:sheldon)
		@other = users(:howard)
		log_in_as(@user)
	end
  
  test "for following page" do
	get following_user_path(@user)
  	assert_not @user.following.empty?
  	assert_match @user.following.count.to_s, response.body
  	@user.following.each do |user|
  		assert_select "a[href=?]", user_path(user)
  	end
  end

  test "for followers page" do
  	get followers_user_path(@user)
  	assert_not @user.followers.empty?
  	assert_match @user.followers.count.to_s, response.body
  	@user.followers.each do |user|
  		assert_select "a[href=?]", user_path(user)
  	end
  end

  test "follow user in standard way" do
  	assert_difference '@user.following.count', 1 do 
  		post relationships_path, followed_id: @other.id
  	end
   end

  test "follow user with AJAX" do
  	assert_difference '@user.following.count', 1 do
  		xhr :post, relationships_path, followed_id: @other.id
  	end
  end

  test "unfollow user" do
  	@user.follow(@other)
  	relationship = @user.active_relationships.find_by(followed_id: @other.id)
  	assert_difference '@user.following.count', -1 do
  		delete relationship_path(relationship)
  	end
  end

  test "unfollow user with AJAX" do
  	@user.follow(@other)
  	relationship = @user.active_relationships.find_by(followed_id: @other.id)
  	assert_difference '@user.following.count', -1 do
  		xhr :delete, relationship_path(relationship)
  	end
  end

end
