FactoryBot.define do
  factory :item do
    storage { nil }
    name { "MyString" }
    description { "MyString" }
    image_url { "MyString" }
    category { nil }
    item_count { 1 }
    updated_by { nil }
    created_by { nil }
  end
end
