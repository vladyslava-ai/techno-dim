require "test_helper"

class AdminReviewRepliesTest < ActionDispatch::IntegrationTest
  setup do
    category = Category.create!(name: "Test category #{SecureRandom.hex(5)}")
    @product = Product.create!(category: category, name: "Test appliance", brand: "Test", price: 1000, stock: 3)
    @review = Review.create!(product: @product, author: "Customer", body: "Everything works", rating: 5)
    @admin = User.create!(name: "Admin", email: "admin-#{SecureRandom.hex(5)}@example.test", password: "password123", role: "admin")
    @customer = User.create!(name: "Customer", email: "customer-#{SecureRandom.hex(5)}@example.test", password: "password123")
  end

  test "admin can publish a reply visible on the product page" do
    post login_path, params: { email: @admin.email, password: "password123" }
    patch admin_review_path(@review), params: { review: { admin_reply: "Дякуємо за відгук!" } }
    assert_response :see_other
    assert_equal "Дякуємо за відгук!", @review.reload.admin_reply
    get product_path(@product)
    assert_response :success
    assert_select ".official-admin-reply", text: /Дякуємо за відгук!/
  end

  test "customer cannot post an administrator reply" do
    post login_path, params: { email: @customer.email, password: "password123" }
    patch admin_review_path(@review), params: { review: { admin_reply: "Not authorized" } }
    assert_response :see_other
    assert_nil @review.reload.admin_reply
  end

  test "admin can remove an existing reply" do
    post login_path, params: { email: @admin.email, password: "password123" }
    patch admin_review_path(@review), params: { review: { admin_reply: "Initial reply" } }
    patch admin_review_path(@review), params: { review: { admin_reply: "" } }
    assert_nil @review.reload.admin_reply
  end
end
