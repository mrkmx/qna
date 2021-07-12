FactoryBot.define do
  factory :answer do
    question { nil }
    body { "MyText" }

    trait :invalid do
      body { nil }
    end
  end
end
