require "test_helper"

class OrderConfirmationJobTest < ActiveJob::TestCase
  test "missing order does not raise" do
    assert_nothing_raised { OrderConfirmationJob.perform_now(-999_999) }
  end
end
