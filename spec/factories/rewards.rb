FactoryBot.define do
  factory :reward do
    title { 'New Reward' }
    association :question, factory: :question
  end
end
