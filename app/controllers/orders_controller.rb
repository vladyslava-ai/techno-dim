class OrdersController < ApplicationController           # [ЗГЕНЕРОВАНО] rails g controller Orders index new show
  # ---- власний код ----
  before_action :require_login                           # оформлення лише для авторизованих (SRS 3.1.4)

  def index
    @orders = current_user.orders.includes(:order_items).order(created_at: :desc)
  end

  def new
    @items = cart_items
    return redirect_to(cart_path, alert: "Кошик порожній", status: :see_other) if @items.empty?   # BR-1
    @total = cart_total(@items)
    @order = Order.new(name: current_user.name, email: current_user.email)
  end

  def create
    @items = cart_items
    return redirect_to(cart_path, alert: "Кошик порожній", status: :see_other) if @items.empty?

    @order = current_user.orders.build(order_params)
    begin
      Order.transaction do
        # Lock rows in a stable order to prevent concurrent overselling.
        locked = @items.sort_by { |product, _| product.id }.map do |product, quantity|
          fresh = Product.lock.find(product.id)
          raise ActiveRecord::RecordInvalid.new(@order) if quantity.to_i <= 0
          if fresh.stock < quantity.to_i
            @order.errors.add(:base, "Недостатньо товару «#{fresh.name}» на складі")
            raise ActiveRecord::RecordInvalid.new(@order)
          end
          [fresh, quantity.to_i]
        end
        @total = locked.sum { |product, quantity| product.price * quantity }
        @order.total = @total
        locked.each do |product, quantity|
          @order.order_items.build(product: product, product_name: product.name,
                                  price: product.price, quantity: quantity)
        end
        @order.save!
        locked.each { |product, quantity| product.update!(stock: product.stock - quantity) }
      end
      session[:cart] = {}
      OrderConfirmationJob.perform_later(@order.id)
      redirect_to @order, status: :see_other
    rescue ActiveRecord::RecordInvalid => error
      @order.errors.add(:base, error.message) if @order.errors.empty?
      @total ||= cart_total(@items)
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @order = admin? ? Order.find(params[:id]) : current_user.orders.find(params[:id])
  end

  private

  def order_params
    params.require(:order).permit(:name, :phone, :email, :city, :address, :delivery, :payment, :comment)
  end
end
