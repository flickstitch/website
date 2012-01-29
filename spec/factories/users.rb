FactoryGirl.define do
  factory :user do
    sequence(:id) { |n| n }
    sequence(:username) { |n| "person#{n}" }
    sequence(:email) { |n| "person#{n}@email.com" }
    password "jjjjjj"
  end
end
