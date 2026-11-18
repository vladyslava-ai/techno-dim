module Admin
  class ProductsController < ApplicationController       # [ЗГЕНЕРОВАНО] rails g controller Admin::Products
    # ---- власний код: адмін-панель, доступ лише для ролі admin (RBAC) ----
    before_action :require_admin
    before_action :set_product, only: %i[edit update destroy]

    def index
      @products = Product.includes(:category).order(:id)
    end

    def new
      @product = Product.new
    end

    def create
      @product = Product.new(product_params)
      if @product.save
        redirect_to admin_products_path, notice: "Товар створено", status: :see_other
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit; end

    def update
      if @product.update(product_params)
        redirect_to admin_products_path, notice: "Товар оновлено", status: :see_other
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @product.destroy
      redirect_to admin_products_path, notice: "Товар видалено", status: :see_other
    end

    private

    def set_product
      @product = Product.find(params[:id])
    end

    def product_params
      params.require(:product).permit(:name, :brand, :description, :specs, :price, :old_price, :stock, :category_id, :image)
    end
  end
end
