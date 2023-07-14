# == Schema Information
#
# Table name: categories
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  storage_id :bigint           not null
#
# Indexes
#
#  index_categories_on_storage_id           (storage_id)
#  index_categories_on_storage_id_and_name  (storage_id,name) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (storage_id => storages.id)
#
class Category < ApplicationRecord
  validates :name, { presence: true }

  belongs_to :storage
  has_many :items, dependent: :nullify
end
