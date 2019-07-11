class User < ApplicationRecord
  attr_accessor :remember_token, :reset_token
  before_save :downcase_email
  has_many :events, dependent: :destroy
	validates :name, presence: false, length: { maximum: 50 } 
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }
  

 # Возвращает дайджест данной строки.
  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # Возвращает случайный токен.
  def self.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # Возвращает true, если данный токен совпадает с дайджестом.
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

  # Устанавливает атрибуты для сброса пароля.
  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute(:reset_digest,  User.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end

  # Отправляет электронное письмо для сброса пароля.
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  # Возвращает true, если истек срок давности ссылки для сброса пароля .
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  private
    # Переводит адрес электронной почты в нижний регистр.
    def downcase_email
      self.email = email.downcase
    end
end
