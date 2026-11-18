require "test_helper"

class OrderTest < ActiveSupport::TestCase
  test "requires customer and shipping details" do
    order = Order.new
    assert_not order.valid?
    assert order.errors[:name].any?
    assert order.errors[:phone].any?
    assert order.errors[:delivery].any?
  end

  test "cannot move delivered order backwards" do
    order = Order.new(status: "Доставлено")
    assert_not order.can_become?("Підтверджено")
    assert_not order.can_become?("Скасовано")
  end

  test "can cancel order before delivery" do
    order = Order.new(status: "Оформлено")
    assert order.can_become?("Скасовано")
  end
end
