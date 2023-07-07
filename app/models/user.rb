class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  VALID_URL_REGEX   = /\A#{URI::DEFAULT_PARSER.make_regexp(%w[http https])}\z/

  validates :name,
            presence: true,
            uniqueness: true,
            length: { minimum: 3, maximum: 15 },
            format: { with: /\A(?=.*[a-zA-Z])[a-zA-Z0-9_]{3,15}\z/ }
  validates :email,
            presence: true,
            format: { with: VALID_EMAIL_REGEX }
  validates :firebase_uid, presence: true, uniqueness: true
  validates :photo_url,
            allow_blank: true,
            format: { with: VALID_URL_REGEX }

end
