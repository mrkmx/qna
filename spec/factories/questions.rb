FactoryBot.define do
  factory :question do
    title { "Question String" }
    body { "Question Text" }
    user

    trait :invalid do
      title { nil }
    end

    trait :with_link do
      after(:create) do |question|
        create :link, linkable: question
      end
    end
  end
end
