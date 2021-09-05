FactoryBot.define do
  sequence :email do |n|
    "test#{n}@example.com"
  end

  factory :user do
    email
    password { 'password' }
    password_confirmation { 'password' }
  end

  trait :admin do
    admin { true }
  end
end
