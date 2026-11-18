class Supplier < ApplicationRecord                       # [ЗГЕНЕРОВАНО] rails g model Supplier
  # ---- власний код ----
  validates :name, :contact, presence: true
end
