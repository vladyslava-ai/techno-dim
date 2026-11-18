class ReviewsController < ApplicationController          # [ЗГЕНЕРОВАНО] rails g controller Reviews create
  before_action :require_login                           # власний код: відгук лише для авторизованих

  def create
    # ---- власний код ----
    product = Product.find(params[:product_id])
    review  = product.reviews.build(review_params.merge(author: current_user.name))

    if review.save
      redirect_to product, notice: "Дякуємо за відгук!", status: :see_other
    else
      redirect_to product, alert: review.errors.full_messages.to_sentence, status: :see_other
    end
  end

  private

  def review_params
    params.require(:review).permit(:rating, :body)
  end
end
