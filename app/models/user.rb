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
  enum state: { active: 0, inactive: 1 }

  has_many :user_storages, dependent: :destroy
  has_many :storages, through: :user_storages
  has_many :created_items, class_name: 'Item', foreign_key: :created_by_id, inverse_of: :created_by, dependent: :destroy
  has_many :updated_items, class_name: 'Item', foreign_key: :updated_by_id, inverse_of: :updated_by, dependent: :nullify

  validates :name,
            presence: true,
            uniqueness: true,
            length: { minimum: 3, maximum: 15 },
            format: { with: /\A(?=.*[a-zA-Z])[a-zA-Z0-9_]{3,15}\z/ }
  validates :email,
            presence: true,
            uniqueness: true,
            format: { with: ValidationConstants::VALID_EMAIL_REGEX }
  validates :firebase_uid, presence: true, uniqueness: true
  validates :photo_url,
            allow_blank: true,
            format: { with: ValidationConstants::VALID_URL_REGEX }

  # ストレージに所属するユーザーをすべて取得する
  def self.storage_members(storage)
    User
      .joins(:user_storages)
      .select('users.name, users.photo_url, user_storages.storage_id, user_storages.role')
      .where(user_storages: { storage: storage })
  end
end
