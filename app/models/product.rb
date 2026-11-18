class Product < ApplicationRecord                        # [ЗГЕНЕРОВАНО] rails g model Product
  belongs_to :category                                   # [ЗГЕНЕРОВАНО] (category:references)

  # ---- власний код ----
  has_many :reviews, dependent: :destroy                 # зв'язок 1 : багато
  has_many :favorites, dependent: :destroy
  has_many :order_items, dependent: :restrict_with_error

  validates :name, :brand, presence: true
  validates :price, numericality: { greater_than: 0 }
  validates :old_price, numericality: { greater_than: 0 }, allow_nil: true     # стара (перекреслена) ціна
  validate  :old_price_above_price
  validates :stock, numericality: { greater_than_or_equal_to: 0, only_integer: true }

  scope :in_stock, -> { where("stock > 0") }             # FR-3.3: товари з нульовим залишком приховано
  scope :matching, ->(q) { where("name LIKE :q OR brand LIKE :q", q: "%#{q}%") if q.present? }

  # відсоток знижки: (стара - нова) / стара; nil, якщо знижки немає
  def discount_percent
    return unless old_price && old_price > price
    ((old_price - price) * 100 / old_price).round
  end

  def average_rating
    reviews.average(:rating)&.round(1) || 0
  end

  # "Потужність: 2000 Вт" -> [["Потужність", "2000 Вт"], ...]  (таблиця характеристик)
  def spec_pairs
    specs.to_s.lines.map { |line| line.strip.split(":", 2).map(&:strip) }.select { |p| p.size == 2 }
  end

  private

  def old_price_above_price
    errors.add(:old_price, "має бути більшою за поточну ціну") if old_price && price && old_price <= price
  end
end
