module Admin
  class OrdersController < BaseController                # [ЗГЕНЕРОВАНО] rails g controller Admin::Orders
    # ---- власний код: перегляд замовлень та зміна статусу (BR-3) ----
    def index
      @orders = Order.includes(:order_items, :user).order(created_at: :desc)
    end

    def update
      order = Order.find(params[:id])
      if order.can_become?(params[:status])
        order.update!(status: params[:status])
        redirect_to admin_orders_path, notice: "Статус замовлення №#{order.id} змінено", status: :see_other
      else
        redirect_to admin_orders_path, alert: "Таку зміну статусу виконати не можна", status: :see_other
      end
    end
  end
end
