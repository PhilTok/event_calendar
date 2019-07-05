require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
	def setup
		@title = "| Event Calendar"
	end	

  test "should get home" do
    get root_url
    assert_response :success
    assert_select "title", "Home #{@title}" 
  end

  test "should get help" do
    get help_url
    assert_response :success
    assert_select "title", "Help #{@title}"
  end

  test "should get contact" do
    get contact_url
    assert_response :success
    assert_select "title", "Contact #{@title}"
  end

  test "should get signup" do
  	get signup_url
  	assert_response :success
  	assert_select "title", "Sign up #{@title}"
  end
end
