require 'test_helper'

class NotificationsTest < ActionMailer::TestCase
  tests Notifications
  def test_new_book
    @expected.subject = 'Notifications#new_book'
    @expected.body    = read_fixture('new_book')
    @expected.date    = Time.now

    assert_equal @expected.encoded, Notifications.create_new_book(@expected.date).encoded
  end

end
