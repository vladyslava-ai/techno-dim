module Admin
  class ReviewsController < BaseController               # [ЗГЕНЕРОВАНО] rails g controller Admin::Reviews
    # ---- власний код: модерація відгуків ----
    def index
      @reviews = Review.includes(:product).order(created_at: :desc)
    end

    def update
      review = Review.find(params[:id])
      reply = params.require(:review).permit(:admin_reply)[:admin_reply].to_s.strip
      if reply.length > 2000
        redirect_to admin_reviews_path, alert: "Відповідь не може перевищувати 2000 символів", status: :see_other
      elsif review.update(admin_reply: reply.presence, admin_replied_at: reply.present? ? Time.current : nil)
        redirect_to admin_reviews_path, notice: reply.present? ? "Відповідь адміністратора збережено" : "Відповідь видалено", status: :see_other
      else
        redirect_to admin_reviews_path, alert: review.errors.full_messages.to_sentence, status: :see_other
      end
    end

    def destroy
      Review.find(params[:id]).destroy
      redirect_to admin_reviews_path, notice: "Відгук видалено", status: :see_other
    end
  end
end
