class HomeController < ApplicationController             # [ЗГЕНЕРОВАНО] rails g controller Home index
  def index                                              # [ЗГЕНЕРОВАНО] порожня дія
    # ---- власний код ----
    @categories = Category.order(:name)
    @counts     = Product.in_stock.group(:category_id).count      # кількість товарів у категорії
    @popular    = Product.in_stock.includes(:reviews, :category).order(created_at: :desc).limit(8)
  end
end
