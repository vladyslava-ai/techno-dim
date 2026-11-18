require "test_helper"

class ComparisonsControllerTest < ActionDispatch::IntegrationTest
  test "comparison page works without selected products" do
    get compare_path
    assert_response :success
    assert_select "h1", "Порівняння товарів"
  end

  test "comparison accepts a product" do
    product = Product.first
    skip "No products in test database" unless product
    post add_to_compare_path(product)
    assert_response :redirect
    follow_redirect!
    assert_response :success
  end
end
