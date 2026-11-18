module Admin
  class StatsController < BaseController                 # [ЗГЕНЕРОВАНО] rails g controller Admin::Stats
    # ---- власний код: підрахунок статистики ----
    def index
      @sales_total = Order.where.not(status: "Скасовано").sum(:total)
      @average_order = Order.where.not(status: "Скасовано").average(:total).to_f
      @monthly_sales = Order.where.not(status: "Скасовано").where(created_at: 5.months.ago.beginning_of_month..Time.current).group_by { |o| o.created_at.beginning_of_month }.transform_values { |orders| orders.sum(&:total) }
      @popular_products = Product.joins(:order_items).group("products.id").order(Arel.sql("SUM(order_items.quantity) DESC")).limit(5).select("products.*, SUM(order_items.quantity) AS units_sold")
      @products_count = Product.count
      @stock_units    = Product.sum(:stock)
      @stock_value    = Product.sum("price * stock")
      @orders_count   = Order.count
      @by_category    = Category.left_joins(:products).group("categories.name").order("categories.name").count("products.id")
      @priciest       = Product.order(price: :desc).first
      @cheapest       = Product.order(price: :asc).first
      @avg_price      = Product.average(:price).to_f
      @in_stock       = Product.where("stock > 0").count
      @low_stock      = Product.where(stock: 1..3).count
      @out_of_stock   = Product.where(stock: 0).count
    end
  end
end
