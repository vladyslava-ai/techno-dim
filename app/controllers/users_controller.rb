class UsersController < ApplicationController            # [ЗГЕНЕРОВАНО] rails g controller Users new
  def new                                                # [ЗГЕНЕРОВАНО] порожня дія
    @user = User.new                                     # власний код
  end

  # ---- власний код: реєстрація покупця (FR-1.1 — FR-1.3) ----
  def create
    @user = User.new(user_params)                        # роль завжди «customer»
    if @user.save
      session[:user_id] = @user.id
      redirect_to root_path, notice: "Реєстрація успішна. Вітаємо, #{@user.name}!", status: :see_other
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
