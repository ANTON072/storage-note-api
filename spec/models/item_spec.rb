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
require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:item_count) }
    it { should validate_numericality_of(:item_count).only_integer.is_greater_than_or_equal_to(0) }
    it { should allow_value('', nil).for(:image_url) }
    it { should allow_value('https://example.com').for(:image_url) }
    it { should_not allow_value('invalid_url').for(:image_url) }
  end

  describe 'associations' do
    it { should belong_to(:storage) }
    it { should belong_to(:category) }
    it { should belong_to(:updated_by).class_name('User') }
    it { should belong_to(:created_by).class_name('User') }
  end

  describe 'scopes' do

    it '指定したユーザーが作成したアイテムのみを返す' do
      user1 = create(:user)
      user2 = create(:user)
      storage = create(:storage)
      category1 = create(:category, storage:)
      category2 = create(:category, storage:)

      item1 = create(:item, created_by: user1, storage:, category: category1)
      item2 = create(:item, created_by: user1, storage:, category: category2)
      item3 = create(:item, created_by: user2, storage:, category: category1)

      items = Item.created_by_user(user1)
      expect(items).to contain_exactly(item1, item2)
      expect(items).not_to include(item3)
    end

    it '指定したユーザーが更新したアイテムのみを返す' do
      user1 = create(:user)
      user2 = create(:user)
      storage = create(:storage)
      category1 = create(:category, storage:)
      category2 = create(:category, storage:)

      item1 = create(:item, created_by: user1, updated_by: user2, storage:, category: category1)
      item2 = create(:item, created_by: user1, updated_by: user2, storage:, category: category2)
      item3 = create(:item, created_by: user2, updated_by: user1, storage:, category: category1)

      items = Item.updated_by_user(user2)
      expect(items).to contain_exactly(item1, item2)
      expect(items).not_to include(item3)
    end

    it '特定のカテゴリーのアイテムのみを返す' do
      user1 = create(:user)
      user2 = create(:user)
      storage = create(:storage)
      category1 = create(:category, storage:)
      category2 = create(:category, storage:)

      item1 = create(:item, created_by: user1, updated_by: user2, storage:, category: category1)
      item2 = create(:item, created_by: user1, updated_by: user2, storage:, category: category2)
      item3 = create(:item, created_by: user2, updated_by: user1, storage:, category: category1)

      items = Item.category_by(category1)
      expect(items).to contain_exactly(item1, item3)
      expect(items).not_to include(item2)
    end
  end
end
