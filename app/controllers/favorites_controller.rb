class FavoritesController < ApplicationController        # [ЗГЕНЕРОВАНО] rails g controller Favorites index --skip-routes
  # ---- власний код: обране доступне лише покупцю (не адміну) ----
  before_action :require_login
  before_action :deny_admin

  def index
    @products = current_user.favorite_products.includes(:category, :reviews).order("favorites.created_at DESC")
  end

  def create
    product = Product.find(params[:product_id])
    current_user.favorites.find_or_create_by(product: product)
    redirect_back fallback_location: favorites_path, notice: "«#{product.name}» додано в обране", status: :see_other
  end

  def destroy
    current_user.favorites.where(product_id: params[:product_id]).destroy_all
    redirect_back fallback_location: favorites_path, notice: "Товар прибрано з обраного", status: :see_other
  end

  private

  def deny_admin
    redirect_to admin_products_path, alert: "Обране доступне лише покупцям", status: :see_other if admin?
  end
end
