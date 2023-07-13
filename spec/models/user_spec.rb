# == Schema Information
#
# Table name: users
#
#  id           :bigint           not null, primary key
#  email        :string           not null
#  firebase_uid :string           not null
#  name         :string           not null
#  photo_url    :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_users_on_email         (email) UNIQUE
#  index_users_on_firebase_uid  (firebase_uid) UNIQUE
#  index_users_on_name          (name) UNIQUE
#
require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { build(:user) }

  context 'validation' do
    context 'valid' do
      it 'validなattributesの場合はvalidである' do
        expect(user).to be_valid
      end
    end

    context 'invalid' do
      it 'nameがないとinvalid' do
        user.name = nil
        expect(user).to_not be_valid
      end

      it 'nameが3文字未満の場合はinvalid' do
        user.name = 'a' * 2
        expect(user).to_not be_valid
      end

      it 'nameが16文字以上の場合はinvalid' do
        user.name = 'a' * 16
        expect(user).to_not be_valid
      end

      it 'firebase_uidがないとinvalid' do
        user.firebase_uid = nil
        expect(user).to_not be_valid
      end

      it 'firebase_uidが重複するとinvalid' do
        create(:user, firebase_uid: 'duplicate_uid')
        user.firebase_uid = 'duplicate_uid'
        expect(user).to_not be_valid
      end

      it 'emailがないとinvalid' do
        user.email = nil
        expect(user).to_not be_valid
      end

      it 'emailが重複するとinvalid' do
        create(:user, email: 'hoge@hoge.com')
        user.email = 'hoge@hoge.com'
        expect(user).to_not be_valid
      end

      it 'emailが不正なアドレスの場合はinvalid' do
        user.email = 'hoge@@hoge'
        expect(user).to_not be_valid
      end

      it 'photo_urlがURLでない場合はinvalid' do
        user.photo_url = 'invalid'
        expect(user).to_not be_valid
      end
    end
  end

  # context 'association' do
  #
  # end

end
