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
  has_many :stocks, dependent: :nullify

  def self.create_default_categories(storage)
    Category.create!([
                       { name: '未分類', storage: storage },
                       { name: '日用品', storage: storage },
                       { name: '食料品', storage: storage },
                       { name: '衣類', storage: storage },
                       { name: '電化製品', storage: storage },
                       { name: 'その他', storage: storage }
                     ])
  end
end
