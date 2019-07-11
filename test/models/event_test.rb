require 'test_helper'

class EventTest < ActiveSupport::TestCase
  def setup
    @user = users(:michael)  
    @event = @user.events.build(name: "BD", content: "Lorem ipsum", datetime: "12.09.2009 19:30")

  end

  test "should be valid" do
    assert @event.valid?
  end

  test "user id should be present" do
    @event.user_id = nil
    assert_not @event.valid?
  end

  test "name should be present" do
    @event.name = "   "
    assert_not @event.valid?
  end

  test "name should be at most 25 characters" do
    @event.name = "a" * 26
    assert_not @event.valid?
  end

  test "content should be at most 140 characters" do
    @event.content = "a" * 141
    assert_not @event.valid?
  end

  test "order should be most near date first" do
    assert_equal events(:cat_video), Event.first
  end
end
