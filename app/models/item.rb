# == Schema Information
#
# Table name: items
#
#  id            :bigint           not null, primary key
#  description   :string
#  image_url     :string
#  item_count    :integer          not null
#  name          :string           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  category_id   :bigint           not null
#  created_by_id :bigint           not null
#  storage_id    :bigint           not null
#  updated_by_id :bigint
#
# Indexes
#
#  index_items_on_category_id    (category_id)
#  index_items_on_created_by_id  (created_by_id)
#  index_items_on_name           (name)
#  index_items_on_storage_id     (storage_id)
#  index_items_on_updated_by_id  (updated_by_id)
#
# Foreign Keys
#
#  fk_rails_...  (category_id => categories.id)
#  fk_rails_...  (created_by_id => users.id)
#  fk_rails_...  (storage_id => storages.id)
#  fk_rails_...  (updated_by_id => users.id)
#
class Item < ApplicationRecord
  validates :name, presence: true
  validates :item_count, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :image_url,
            allow_blank: true,
            format: { with: ValidationConstants::VALID_URL_REGEX }

  belongs_to :storage
  belongs_to :category
  belongs_to :updated_by, class_name: 'User'
  belongs_to :created_by, class_name: 'User'

  scope :created_by_user, ->(user) { where(created_by: user) }
  scope :updated_by_user, ->(user) { where(updated_by: user) }
  scope :category_by, ->(category) { where(category:) }
end
