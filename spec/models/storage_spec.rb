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
require 'rails_helper'

RSpec.describe Storage, type: :model do
  subject(:storage) { build(:storage) }

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_length_of(:name).is_at_least(3).is_at_most(20) }

    context 'image_urlはURL形式のみ許可' do
      subject(:storage) do
        build(:storage, image_url: 'https://example.com/image.png')
      end

      it { should allow_value(storage.image_url).for(:image_url) }
    end

    context 'image_urlはURL形式以外はinvalid' do
      subject(:storage) do
        build(:storage, image_url: 'image')
      end

      it { should_not allow_value(storage.image_url).for(:image_url) }
    end
  end

  describe 'callbacks' do
    it 'create前にユニークなslugをつくる' do
      storage = FactoryBot.build(:storage)
      # コールバックの発火
      storage.valid?
      expect(storage.slug).not_to be_nil
    end

    it 'slugは重複するとinvalid' do
      existing_slug = 'existing_slug'
      storage = FactoryBot.create(:storage, slug: existing_slug)
      storage.valid?
      expect(storage.slug).to eq(existing_slug)
    end
  end

  describe 'associations' do
    it { should have_many(:user_storages).dependent(:destroy) }
    it { should have_many(:users).through(:user_storages) }
    it { should have_many(:items).dependent(:destroy) }
    it { should have_many(:categories).dependent(:destroy) }
  end
end
