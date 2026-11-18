class Category < ApplicationRecord                       # [ЗГЕНЕРОВАНО] rails g model Category
  # ---- власний код ----
  has_many :products, dependent: :restrict_with_error    # BR-5: не можна видалити категорію з товарами
  validates :name, presence: true, uniqueness: true
end
