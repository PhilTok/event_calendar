require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  test "password_reset" do
    user = users(:michael)
    user.reset_token = User.new_token
    mail = UserMailer.password_reset(user)
    assert_equal "Password reset", mail.subject
    assert_equal [user.email], mail.to
    assert_equal ["noreply@example.com"], mail.from    
    assert_match user.reset_token,        mail.text_part.body.to_s.encode("UTF-8")
    assert_match CGI::escape(user.email), mail.text_part.body.to_s.encode("UTF-8")
  end
end
