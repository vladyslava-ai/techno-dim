class Review < ApplicationRecord                         # [ЗГЕНЕРОВАНО] rails g model Review
  belongs_to :product                                    # [ЗГЕНЕРОВАНО] (product:references)

  # ---- власний код ----
  validates :author, :body, presence: true
  validates :rating, inclusion: { in: 1..5 }             # FR-4.5: оцінка від 1 до 5
  validates :admin_reply, length: { maximum: 2000 }, allow_blank: true
end
