FactoryBot.define do
  factory :authorization do
    provider { 'provider' }
    uid { '12345678' }
    user { nil }
  end
end
