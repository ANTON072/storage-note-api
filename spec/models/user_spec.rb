# == Schema Information
#
# Table name: users
#
#  id           :bigint           not null, primary key
#  email        :string           not null
#  firebase_uid :string           not null
#  name         :string           not null
#  photo_url    :string
#  state        :integer          default("active"), not null
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
  subject(:user) { build(:user) }

  describe 'validations' do
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email) }
    it { should validate_presence_of(:firebase_uid) }
    it { should validate_uniqueness_of(:firebase_uid) }
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
    it { should validate_length_of(:name).is_at_least(3).is_at_most(15) }

    context 'nameは英字のみvalid' do
      subject(:user) do
        build(:user, name: 'taro')
      end

      it { should allow_value(user.name).for(:name) }
    end

    context 'nameは英字と数字のみでもvalid' do
      subject(:user) do
        build(:user, name: '1abc')
      end

      it { should allow_value(user.name).for(:name) }
    end

    context 'nameは記号は_だけ許可' do
      subject(:user) do
        build(:user, name: '1ab_c')
      end

      it { should allow_value(user.name).for(:name) }
    end

    context 'nameは数字のみだとinvalid' do
      subject(:user) do
        build(:user, name: '1234')
      end

      it { should_not allow_value(user.name).for(:name) }
    end

    context 'nameに_以外の記号が入るとinvalid' do
      subject(:user) do
        build(:user, name: 'abcd?')
      end

      it { should_not allow_value(user.name).for(:name) }
    end

    context 'photo_urlはURL形式のみ許可' do
      subject(:user) do
        build(:user, photo_url: 'https://example.com/image.png')
      end

      it { should allow_value(user.photo_url).for(:photo_url) }
    end

    context 'photo_urlはURL形式以外はinvalid' do
      subject(:user) do
        build(:user, photo_url: 'image')
      end

      it { should_not allow_value(user.photo_url).for(:photo_url) }
    end
  end

  describe 'associations' do
    it { should have_many(:user_storages).dependent(:destroy) }
    it { should have_many(:storages).through(:user_storages) }
    it {
      should have_many(:created_stocks)
        .class_name('Stock')
        .with_foreign_key('created_by_id')
        .inverse_of(:created_by)
        .dependent(:destroy)
    }
    it {
      should have_many(:updated_stocks)
        .class_name('Stock')
        .with_foreign_key('updated_by_id')
        .inverse_of(:updated_by)
        .dependent(:nullify)
    }
  end
end
