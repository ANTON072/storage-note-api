# == Schema Information
#
# Table name: storages
#
#  id          :bigint           not null, primary key
#  description :string
#  image_url   :string
#  name        :string           not null
#  slug        :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_storages_on_slug  (slug) UNIQUE
#
class Storage < ApplicationRecord
  before_validation :generate_slug, on: :create

  validates :name,
            presence: true,
            length: { minimum: 3, maximum: 20 }
  validates :slug,
            presence: true,
            uniqueness: true
  validates :image_url,
            allow_blank: true,
            format: { with: ValidationConstants::VALID_URL_REGEX }

  has_many :user_storages, dependent: :destroy
  has_many :users, through: :user_storages
  has_many :items, dependent: :destroy
  has_many :categories, dependent: :destroy

  private

  def generate_slug
    self.slug ||= ULID.generate
  end
end
