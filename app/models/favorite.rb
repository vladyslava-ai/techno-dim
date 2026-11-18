class Favorite < ApplicationRecord                       # [ЗГЕНЕРОВАНО] rails g model Favorite user:references product:references
  belongs_to :user                                       # [ЗГЕНЕРОВАНО] (user:references)
  belongs_to :product                                    # [ЗГЕНЕРОВАНО] (product:references)

  # ---- власний код ----
  validates :product_id, uniqueness: { scope: :user_id } # один товар не можна додати в обране двічі
end
