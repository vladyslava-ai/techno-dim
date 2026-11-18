class ApplicationController < ActionController::Base     # [ЗГЕНЕРОВАНО] rails new

  # ---- власний код ----
  helper_method :cart_count, :current_user, :admin?, :favorite_ids

  private

  # Кошик зберігається в сесії: { "id_товару" => кількість }  (FR-4.1, FR-4.2)
  def cart
    session[:cart] ||= {}
  end

  def cart_count
    cart.values.sum
  end

  # [[товар, кількість], ...] та загальна сума
  def cart_items
    cart.filter_map do |id, qty|
      product = Product.find_by(id: id)
      [product, qty] if product
    end
  end

  def cart_total(items = cart_items)
    items.sum { |product, qty| product.price * qty }
  end

  # Поточний користувач (з сесії) та перевірка ролі
  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def admin?
    current_user&.admin?
  end

  # id товарів в обраному поточного користувача (для сердечок на картках)
  def favorite_ids
    @favorite_ids ||= current_user ? current_user.favorites.pluck(:product_id) : []
  end

  def require_login
    redirect_to login_path, alert: "Увійдіть, щоб продовжити", status: :see_other unless current_user
  end

  def require_admin
    redirect_to root_path, alert: "Доступ лише для адміністратора", status: :see_other unless admin?
  end
end
