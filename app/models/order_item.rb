class OrderItem < ApplicationRecord                      # [ЗГЕНЕРОВАНО] rails g model OrderItem
  belongs_to :product, optional: true
  belongs_to :order                                      # [ЗГЕНЕРОВАНО] (order:references)
  # ---- власний код: назва та ціна зберігаються на момент замовлення (BR-2) ----
  def subtotal
    price * quantity
  end
end
