require "test_helper"

class ProductValidationTest < ActiveSupport::TestCase
  setup do
    @category = Category.create!(name: "Kitchen #{SecureRandom.hex(5)}")
  end

  test "requires name and brand and positive price" do
    product = Product.new(category: @category, name: "", brand: "", price: -1, stock: -1)
    assert_not product.valid?
    assert product.errors[:name].any?
    assert product.errors[:brand].any?
    assert product.errors[:price].any?
    assert product.errors[:stock].any?
  end

  test "accepts valid product and calculates discount" do
    product = Product.create!(category: @category, name: "Refrigerator", brand: "Demo", price: 800, old_price: 1000, stock: 5)
    assert_equal 20, product.discount_percent
    assert_equal 5, product.reload.stock
  end

  test "rejects an old price below current price" do
    product = Product.new(category: @category, name: "Fridge", brand: "Demo", price: 1000, old_price: 900, stock: 2)
    assert_not product.valid?
    assert product.errors[:old_price].any?
  end
end
