require 'test_helper'

class UsersProfileTest < ActionDispatch::IntegrationTest
	include ApplicationHelper
	def setup
    @user = users(:michael)
  end

  test "profile display" do
    get user_path(@user)
    assert_template 'users/show'
    assert_select 'title', @user.name + " | Event Calendar"
    assert_select 'h1', text: @user.name
    assert_match @user.events.count.to_s, response.body.to_s
    @user.events.each do |event|
    	assert_match event.name, response.body.to_s.encode("UTF-8")
      assert_match event.content, response.body.to_s.encode("UTF-8")
      assert_match event.datetime.strftime("%d.%m.%Y"), response.body.to_s.encode("UTF-8")
      assert_match event.datetime.strftime("%H:%M"), response.body.to_s.encode("UTF-8")
    end
  end
end
