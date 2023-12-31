# == Schema Information
#
# Table name: user_storages
#
#  id         :bigint           not null, primary key
#  role       :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  storage_id :bigint           not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_user_storages_on_storage_id  (storage_id)
#  index_user_storages_on_user_id     (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (storage_id => storages.id)
#  fk_rails_...  (user_id => users.id)
#
FactoryBot.define do
  factory :user_storage do
    association :user
    association :storage
    role { :member }
  end
end
