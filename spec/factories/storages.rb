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
FactoryBot.define do
  factory :storage do
    name { Faker::Name.unique.name }
    description { Faker::Lorem.sentence }
  end
end
