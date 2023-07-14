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
require 'rails_helper'

RSpec.describe UserStorage, type: :model do
  describe 'validations' do
    it { is_expected.to define_enum_for(:role).with_values(member: 0, owner: 1) }

    it 'は:roleがnilでないことを検証すること' do
      user_storage = build(:user_storage, role: nil)
      user_storage.valid?
      expect(user_storage.errors[:role]).to include('を入力してください')
    end
  end

  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:storage) }
  end

  describe 'callbacks' do
    describe '#prevent_owner_removal' do
      context 'roleがオーナーの場合' do
        let(:storage) { create(:storage) }
        let(:owner) { create(:user) }
        let(:member) { create(:user) }

        before do
          create(:user_storage, user: owner, storage:, role: :owner)
          create(:user_storage, user: member, storage:, role: :member)
        end

        it 'ユーザーストレージの削除を防ぐことはできません' do
          user_storage = owner.user_storages.find_by(storage: storage)
          expect { user_storage.destroy }.to change(UserStorage, :count).by(-1)
        end
      end
    end
  end

  describe 'class methods' do
    describe '.create_member' do
      let(:user) { create(:user) }
      let(:storage) { create(:storage) }

      it 'memberロールを持つユーザーストレージを作成する' do
        user_storage = UserStorage.create_member(user, storage)
        expect(user_storage.role).to eq('member')
        expect(user_storage.user).to eq(user)
        expect(user_storage.storage).to eq(storage)
      end
    end

    describe '.create_owner' do
      let(:user) { create(:user) }
      let(:storage) { create(:storage) }

      it 'ownerロールを持つユーザーストレージを作成する' do
        user_storage = UserStorage.create_owner(user, storage)
        expect(user_storage.role).to eq('owner')
        expect(user_storage.user).to eq(user)
        expect(user_storage.storage).to eq(storage)
      end
    end
  end
end
