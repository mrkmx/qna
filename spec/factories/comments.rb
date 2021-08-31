FactoryBot.define do
  factory :comment do
    body { 'New comment' }
    user { nil }

    trait :invalid do
      body { nil }
    end
  end
end
