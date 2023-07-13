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
  has_many :user_storages, dependent: :destroy
  has_many :users, through: :user_storages
  has_many :items, dependent: :destroy
  has_many :categories, dependent: :destroy
end
