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
#  updated_by_id :bigint           not null
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
FactoryBot.define do
  factory :item do
    association :storage
    association :category
    association :created_by, factory: :user
    association :updated_by, factory: :user
    name { Faker::Lorem.word }
    description { Faker::Lorem.sentence }
    item_count { Faker::Number.between(from: 1, to: 10) }
    image_url { Faker::Internet.url }
  end
end
