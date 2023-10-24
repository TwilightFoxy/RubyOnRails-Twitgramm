FactoryBot.define do
  factory :comment do
    body { "Sample comment body" }
    association :user
    association :post
  end
end