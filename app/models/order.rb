class Order < ApplicationRecord                          # [ЗГЕНЕРОВАНО] rails g model Order
  belongs_to :user                                       # [ЗГЕНЕРОВАНО] (user:references)

  # ---- власний код ----
  has_many :order_items, dependent: :destroy

  STATUSES   = ["Оформлено", "Підтверджено", "Передано в доставку", "Доставлено", "Скасовано"].freeze  # BR-3
  DELIVERIES = ["Нова Пошта", "Кур'єр", "Самовивіз", "Укрпошта"].freeze
  PAYMENTS   = ["Карткою онлайн", "Накладений платіж"].freeze

  attribute :status, :string, default: STATUSES.first

  validates :name, :phone, :city, :address, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_blank: true
  validates :delivery, inclusion: { in: DELIVERIES }
  validates :payment,  inclusion: { in: PAYMENTS }
  validates :status,   inclusion: { in: STATUSES }

  # BR-3: статус змінюється лише вперед; скасувати можна до доставки
  def can_become?(new_status)
    return false unless STATUSES.include?(new_status)
    return false if %w[Доставлено Скасовано].include?(status)
    new_status == "Скасовано" || STATUSES.index(new_status) >= STATUSES.index(status)
  end
end
