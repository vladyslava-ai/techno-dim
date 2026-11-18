# Asynchronous, privacy-conscious order event; no real email is sent.
# Connect Action Mailer to a configured provider before enabling email delivery.
class OrderConfirmationJob < ApplicationJob
  queue_as :default

  def perform(order_id)
    order = Order.find_by(id: order_id)
    return unless order

    Rails.logger.info("[TechnoDim] Order ##{order.id} created; status=#{order.status}")
  end
end
