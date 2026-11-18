require "test_helper"

class UserValidationTest < ActiveSupport::TestCase
  test "normalizes email and enforces uniqueness" do
    User.create!(name: "One", email: " Test@Example.com ", password: "password123")
    duplicate = User.new(name: "Two", email: "test@example.com", password: "password123")
    assert_not duplicate.valid?
    assert duplicate.errors[:email].any?
  end

  test "password must be at least eight characters" do
    user = User.new(name: "One", email: "one@example.com", password: "short")
    assert_not user.valid?
  end
end
