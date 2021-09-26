FactoryBot.define do
  factory :search do
    query { 'Some title' }
    scope { 'All scopes' }
  end
end
