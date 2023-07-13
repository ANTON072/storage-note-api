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
