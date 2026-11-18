class SessionsController < ApplicationController         # [ЗГЕНЕРОВАНО] rails g controller Sessions new
  def new                                                # [ЗГЕНЕРОВАНО] порожня дія
  end

  # ---- власний код ----
  def create
    user = User.find_by(email: params[:email].to_s.downcase.strip)
    if user&.authenticate(params[:password])
      saved_cart = session[:cart]
      reset_session                                      # захист від session fixation
      session[:cart] = saved_cart if saved_cart
      session[:user_id] = user.id
      target = user.admin? ? admin_products_path : root_path   # FR-2.5
      redirect_to target, notice: "Вітаємо, #{user.name}!", status: :see_other
    else
      flash.now[:alert] = "Невірний email або пароль"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session.delete(:user_id)
    redirect_to root_path, notice: "Ви вийшли з облікового запису", status: :see_other
  end
end
