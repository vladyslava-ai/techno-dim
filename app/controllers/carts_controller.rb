class CartsController < ApplicationController            # [ЗГЕНЕРОВАНО] rails g controller Carts show
  # ---- власний код ----
  before_action :deny_admin                               # адміністратор не робить покупок
  def show
    @items = cart_items
    @total = cart_total(@items)
  end

  def add
    product = Product.find(params[:product_id])
    key = product.id.to_s
    cart[key] = [cart.fetch(key, 0) + 1, product.stock].min
    redirect_back fallback_location: cart_path, notice: "«#{product.name}» додано до кошика", status: :see_other
  end

  def update_item
    key = params[:product_id].to_s
    qty = params[:quantity].to_i
    if qty <= 0
      cart.delete(key)
    elsif (product = Product.find_by(id: key))
      cart[key] = [qty, product.stock].min
    end
    redirect_to cart_path, status: :see_other
  end

  def remove
    cart.delete(params[:product_id].to_s)
    redirect_to cart_path, notice: "Товар видалено з кошика", status: :see_other
  end

  private

  def deny_admin
    redirect_to admin_products_path, alert: "Адміністратор не користується кошиком", status: :see_other if admin?
  end
end
