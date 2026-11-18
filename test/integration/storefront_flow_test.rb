require "test_helper"

class StorefrontFlowTest < ActionDispatch::IntegrationTest
  setup do
    @category = Category.create!(name: "Appliances #{SecureRandom.hex(4)}")
    @product = Product.create!(category: @category, name: "Test fridge", brand: "Demo", price: 1000, stock: 3)
  end

  test "catalog and product page are accessible" do
    get products_path
    assert_response :success
    get product_path(@product)
    assert_response :success
  end

  test "guest can add item to cart but must sign in to checkout" do
    post add_to_cart_path(@product)
    assert_response :see_other
    get cart_path
    assert_response :success
    get new_order_path
    assert_response :see_other
  end

  test "signed-in customer can place order and stock decreases" do
    user = User.create!(name: "Test Buyer", email: "buyer@example.test", password: "password123")
    post login_path, params: { email: user.email, password: "password123" }
    post add_to_cart_path(@product)
    assert_difference("Order.count", 1) do
      post orders_path, params: { order: { name: "Test Buyer", phone: "0991234567", email: user.email,
        city: "Kyiv", address: "Test street 1", delivery: "Нова Пошта", payment: "Накладений платіж" } }
    end
    assert_response :see_other
    assert_equal 2, @product.reload.stock
  end
end
