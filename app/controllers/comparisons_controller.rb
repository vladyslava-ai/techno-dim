class ComparisonsController < ApplicationController
  MAX_PRODUCTS = 3

  def index
    @products = Product.where(id: comparison_ids).includes(:category).index_by(&:id)
    @products = comparison_ids.filter_map { |id| @products[id] }
    @spec_names = @products.flat_map { |p| p.spec_pairs.map(&:first) }.uniq
  end

  def add
    product = Product.find(params[:product_id])
    ids = comparison_ids
    if !ids.include?(product.id) && ids.size >= MAX_PRODUCTS
      redirect_back fallback_location: compare_path, alert: "Можна порівняти не більше трьох товарів"
      return
    end
    session[:compare_ids] = (ids + [product.id]).uniq
    redirect_back fallback_location: compare_path, notice: "Товар додано до порівняння"
  end

  def remove
    session[:compare_ids] = comparison_ids - [params[:product_id].to_i]
    redirect_to compare_path, status: :see_other
  end

  private

  def comparison_ids
    Array(session[:compare_ids]).map(&:to_i).uniq.first(MAX_PRODUCTS)
  end
end
