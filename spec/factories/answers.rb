FactoryBot.define do
  factory :answer do
    body { "Answer Text" }
    question
    user
    best { false }

    trait :invalid do
      body { nil }
    end

    trait :with_link do
      after(:create) do |question|
        create :link, linkable: question
      end
    end
    
  end
end
