# == Schema Information
#
# Table name: stocks
#
#  id                :bigint           not null, primary key
#  alert_threshold   :integer
#  description       :string
#  image_url         :string
#  is_favorite       :boolean
#  item_count        :integer          not null
#  name              :string           not null
#  price             :string
#  purchase_location :string
#  unit_name         :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  category_id       :bigint
#  created_by_id     :bigint
#  storage_id        :bigint           not null
#  updated_by_id     :bigint
#
# Indexes
#
#  index_stocks_on_category_id    (category_id)
#  index_stocks_on_created_by_id  (created_by_id)
#  index_stocks_on_name           (name)
#  index_stocks_on_storage_id     (storage_id)
#  index_stocks_on_updated_by_id  (updated_by_id)
#
# Foreign Keys
#
#  fk_rails_...  (category_id => categories.id)
#  fk_rails_...  (created_by_id => users.id)
#  fk_rails_...  (storage_id => storages.id)
#  fk_rails_...  (updated_by_id => users.id)
#
FactoryBot.define do
  factory :stock do
    
  end
end
