class ProductsController < ApplicationController         # [ЗГЕНЕРОВАНО] rails g controller Products index show
  PER_PAGE = 6                                           # власний код: товарів на сторінці

  def index
    # ---- власний код: пошук, фільтри та сортування (FR-4.4, FR-4.7) ----
    @categories = Category.order(:name)
    @brands     = Product.in_stock.group(:brand).order(:brand).count   # {"Samsung" => 24}

    products = Product.in_stock.includes(:category, :reviews).matching(params[:q])
    products = products.where(category_id: params[:category_id]) if params[:category_id].present?
    products = products.where(brand: params[:brand])             if params[:brand].present?
    products = products.where("price >= ?", params[:min_price])  if params[:min_price].present?
    products = products.where("price <= ?", params[:max_price])  if params[:max_price].present?

    products = case params[:sort]
               when "price_asc"  then products.order(price: :asc)
               when "price_desc" then products.order(price: :desc)
               else products.order(created_at: :desc)
               end

    # пагінація без додаткових gem: PER_PAGE товарів на сторінку
    @total       = products.count
    @total_pages = [(@total / PER_PAGE.to_f).ceil, 1].max
    @page        = params[:page].to_i.clamp(1, @total_pages)
    @products    = products.offset((@page - 1) * PER_PAGE).limit(PER_PAGE)
  end

  def show
    # ---- власний код ----
    @product = Product.find(params[:id])
    @reviews = @product.reviews.order(created_at: :desc)
    @review  = Review.new
    @related = Product.in_stock.where(category_id: @product.category_id).where.not(id: @product.id).limit(4)
  end
end
