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
FactoryBot.define do
  factory :user do
    sequence(:firebase_uid) { |n| "firebase_#{n}" }
    sequence(:name) { |n| "user_#{n}" }
    sequence(:email) { |n| "user_#{n}@example.com" }
    photo_url { 'https://example.com/photo.jpg' }
    state { 0 }

    trait :deactivated do
      state { 1 }
    end
  end
end
