# == Schema Information
#
# Table name: users
#
#  id           :bigint           not null, primary key
#  email        :string           not null
#  firebase_uid :string           not null
#  name         :string           not null
#  photo_url    :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_users_on_email         (email) UNIQUE
#  index_users_on_firebase_uid  (firebase_uid) UNIQUE
#  index_users_on_name          (name) UNIQUE
#
class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  VALID_URL_REGEX   = /\A#{URI::DEFAULT_PARSER.make_regexp(%w[http https])}\z/

  # TODO: ストレージオーナーの場合はストレージの削除が必要
  has_many :user_storages, dependent: :destroy
  has_many :storages, through: :user_storages
  has_many :created_items, class_name: 'Item', foreign_key: :created_by_id, inverse_of: :created_by, dependent: :nullify
  has_many :updated_items, class_name: 'Item', foreign_key: :updated_by_id, inverse_of: :updated_by, dependent: :nullify

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
