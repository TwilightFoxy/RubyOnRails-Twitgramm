FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "test#{n}@example.com" }
    password { "password" }
    sequence(:nickname) { |n| "testnick#{n}" }
  end
end
