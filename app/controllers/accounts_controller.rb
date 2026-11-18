class AccountsController < ApplicationController
  before_action :require_login

  def show
    @orders = current_user.orders.includes(:order_items).order(created_at: :desc)
    @favorites_count = current_user.favorites.count
    @spent = @orders.reject { |order| order.status == "Скасовано" }.sum(&:total)
  end
end
