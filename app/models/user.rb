class User < ApplicationRecord                           # [ЗГЕНЕРОВАНО] rails g model User
  # ---- власний код ----
  has_many :orders
  has_many :favorites, dependent: :destroy                # обране користувача
  has_many :favorite_products, through: :favorites, source: :product
  has_secure_password                                    # bcrypt-хеш пароля (NFR-S2), password_digest

  attribute :role, :string, default: "customer"          # customer | admin  (RBAC, NFR-S3)

  validates :name, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false },
                    format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, length: { minimum: 8 }, allow_nil: true   # FR-1.3
  before_validation { self.email = email.to_s.downcase.strip }

  def admin?
    role == "admin"
  end
end
