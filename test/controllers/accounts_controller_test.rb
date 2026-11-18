require "test_helper"

class AccountsControllerTest < ActionDispatch::IntegrationTest
  test "guest is redirected to login" do
    get account_path
    assert_redirected_to login_path
  end
end
